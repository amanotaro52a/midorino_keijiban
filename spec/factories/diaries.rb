FactoryBot.define do
  factory :diary do
    title { "Sample Diary" }
    summary_content { "This is a summary of the diary." }
    plant_name { "Tomato" }
    variety_name { "Cherry Tomato" }
    cultivation_method { "Hydroponics" }
    cultivation_location { "Greenhouse" }
    user
  end
end
