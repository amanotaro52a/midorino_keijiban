class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  mount_uploader :image, PostImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, length: { maximum: 65_535 }
  validates :image, presence: true
  validates :plant_name, length: { maximum: 100 }


  def self.ransackable_attributes(auth_object = nil)
    [ "title", "body", "plant_name" ]
  end
end
