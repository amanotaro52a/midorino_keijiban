FactoryBot.define do
  factory :post do
    title { "Sample Post" }
    body { "This is a body of the post." }
    plant_name { "Monstera" }
    user
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/file/testimage.jpg"), "image/jpeg") }
  end
end
