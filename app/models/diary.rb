class Diary < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65_535 }
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "diary_image", "id", "title", "updated_at", "user_id",]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  belongs_to :user
  mount_uploader :diary_image, DiaryImageUploader
end
