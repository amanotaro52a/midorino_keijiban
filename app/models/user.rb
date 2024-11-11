class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  has_many :diaries, dependent: :destroy
  has_one_attached :avatar
  def deliver_reset_password_instructions!
    # Sorcery のデフォルトのパスワードリセット処理を呼び出す
    super
    UserMailer.reset_password_email(self).deliver_later
  end
end
