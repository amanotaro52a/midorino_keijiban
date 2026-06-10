FactoryBot.define do
  factory :post do
    title { "Sample Post" }
    body { "This is a body of the post." }
    plant_name { "Monstera" }
    user
  end
end
