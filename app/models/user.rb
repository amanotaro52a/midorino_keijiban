class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader
  has_many :authentications, dependent: :destroy

  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  # Googleログインでユーザー作成または取得
  def self.create_from_provider(provider, uid, user_info)
    user = where(email: user_info["email"]).first_or_initialize
    user.authentications.build(provider: provider, uid: uid)
    user.save(validate: false)
    user
    if user.save
      user
    else
      Rails.logger.error "User creation failed: #{user.errors.full_messages}"
      nil
    end    
  end

  has_many :diaries, dependent: :destroy
  has_one_attached :avatar
  def deliver_reset_password_instructions!
    # Sorcery のデフォルトのパスワードリセット処理を呼び出す
    super
    UserMailer.reset_password_email(self).deliver_later
  end
end
