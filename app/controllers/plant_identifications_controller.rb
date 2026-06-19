class PlantIdentificationsController < ApplicationController
  def create
    unless params[:image].present?
      return render json: { error: "画像を選択してください" }, status: :unprocessable_entity
    end

    unless valid_image?(params[:image])
      return render json: { error: "画像ファイルを選択してください" }, status: :unprocessable_entity
    end

    result = PlantNetClient.new.identify(params[:image])

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: { results: result[:results].map(&:to_h) }
    end
  end

  private

  def valid_image?(file)
    file.respond_to?(:content_type) && file.content_type.to_s.start_with?("image/")
  end
end
