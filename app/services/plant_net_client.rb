class PlantNetClient
  API_URL = "https://my-api.plantnet.org/v2/identify/all"
  MAX_RESULTS = 3
  TIMEOUT = 10

  Result = Struct.new(:scientific_name, :genus, :display_name, :score, keyword_init: true)

  def initialize
    @api_key = Rails.application.config.x.plantnet_api_key
    @client = Faraday.new do |f|
      f.request :multipart
      f.request :url_encoded
      f.options.timeout = TIMEOUT
      f.options.open_timeout = TIMEOUT
      f.adapter Faraday.default_adapter
    end
    @ja_dict = load_ja_dict
  end

  # uploaded_file: ActionDispatch::Http::UploadedFile
  # 戻り値: { results: [Result, ...] } または { error: String }
  def identify(uploaded_file)
    return { error: "APIキーが設定されていません" } if @api_key.blank?

    response = @client.post(API_URL) do |req|
      req.params["api-key"]    = @api_key
      req.params["nb-results"] = MAX_RESULTS
      req.body = {
        "images" => Faraday::FilePart.new(
          uploaded_file.tempfile,
          uploaded_file.content_type,
          uploaded_file.original_filename
        ),
        "organs" => "auto"
      }
    end

    parse_response(response)
  rescue Faraday::TimeoutError
    { error: "通信がタイムアウトしました。もう一度お試しください" }
  rescue Faraday::Error => e
    Rails.logger.error("[PlantNetClient] #{e.class}: #{e.message}")
    { error: "通信エラーが発生しました" }
  end

  private

  def load_ja_dict
    path = Rails.root.join("config", "plant_names_ja.yml")
    YAML.load_file(path) || {}
  rescue Errno::ENOENT, Psych::SyntaxError => e
    Rails.logger.error("[PlantNetClient] 辞書読込失敗: #{e.message}")
    {}
  end

  def parse_response(response)
    case response.status
    when 200
      build_results(response.body)
    when 404
      { error: "植物を識別できませんでした" }
    when 401, 403
      Rails.logger.error("[PlantNetClient] 認証エラー: #{response.status}")
      { error: "APIの認証に失敗しました" }
    when 429
      { error: "APIの利用上限に達しました。時間をおいて再度お試しください" }
    else
      Rails.logger.error("[PlantNetClient] 想定外のステータス: #{response.status} body=#{response.body}")
      { error: "識別に失敗しました。別の画像で再度お試しください" }
    end
  end

  def build_results(raw_body)
    data = JSON.parse(raw_body)
    candidates = data["results"] || []
    return { error: "植物を識別できませんでした" } if candidates.empty?

    results = candidates.map do |r|
      species = r["species"] || {}
      genus   = species.dig("genus", "scientificNameWithoutAuthor")
      sci     = species["scientificNameWithoutAuthor"]

      Result.new(
        scientific_name: sci,
        genus:           genus,
        display_name:    japanese_name_for(genus) || sci,
        score:           r["score"].to_f.round(4)
      )
    end

    { results: results }
  rescue JSON::ParseError => e
    Rails.logger.error("[PlantNetClient] JSON解析失敗: #{e.message}")
    { error: "レスポンスの解析に失敗しました" }
  end

  def japanese_name_for(genus)
    return nil if genus.blank?
    @ja_dict[genus]
  end
end
