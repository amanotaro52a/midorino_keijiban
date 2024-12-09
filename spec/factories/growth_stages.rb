FactoryBot.define do
  factory :growth_stage do
    stage_name { "Seedling" }
    description { "This is the seedling stage." }
    image do
      file = Tempfile.new(['sample_image', '.png'])
      file.write("fake image content") # 仮の画像データを書き込む
      file.rewind
      Rack::Test::UploadedFile.new(file.path, 'image/png')
    ensure
      file.close
      file.unlink # テスト終了後に削除
    end
  end
end
