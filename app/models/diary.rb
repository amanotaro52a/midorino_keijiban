class Diary < ApplicationRecord
  belongs_to :user
  has_many :growth_stages, dependent: :destroy
  accepts_nested_attributes_for :growth_stages, allow_destroy: true

  mount_uploader :thumbnail_image, ThumbnailImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :summary_content, presence: true, length: { maximum: 65_535 }
  validates :plant_name, presence: true, length: { maximum: 100 }
  validates :variety_name, length: { maximum: 100 }, allow_blank: true
  validates :cultivation_method, length: { maximum: 50 }, allow_blank: true
  validates :cultivation_location, length: { maximum: 50 }, allow_blank: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "summary_content", "thumbnail_image", "title", "updated_at", "user_id", "plant_name", "variety_name", "cultivation_method", "cultivation_location"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
