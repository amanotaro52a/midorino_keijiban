class GrowthStage < ApplicationRecord
  belongs_to :diary

  mount_uploader :image, GrowthStageImageUploader


  validates :growth_stage_contents, presence: true
  validates :image, presence: true
end
