require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    it '有効なUserを持つ場合、有効であること' do
      expect(user).to be_valid
    end

    it '名前が空の場合、無効であること' do
      user.name = nil
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it '名前が255文字を超える場合、無効であること' do
      user.name = 'a' * 256
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("は255文字以内で入力してください")
    end

    it 'メールアドレスが空の場合、無効であること' do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'メールアドレスが一意でない場合、無効であること' do
      create(:user, email: 'test@example.com')
      user.email = 'test@example.com'
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it 'メールアドレスが大文字小文字の違いだけの場合、無効であること' do
      user1 = create(:user, email: 'testuser@example.com')
      user2 = build(:user, email: 'TESTUSER@EXAMPLE.COM')
      expect(user2).to_not be_valid
      expect(user2.errors[:email]).to include("はすでに存在します")
    end

    it 'パスワードが3文字未満の場合、無効であること' do
      user.password = '12'
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end

    it 'パスワードと確認用パスワードが一致しない場合、無効であること' do
      user.password = 'password'
      user.password_confirmation = 'different'
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end

  describe 'パスワードリセット' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'パスワードリセットメールが送信されること' do
      perform_enqueued_jobs do
        expect {
          user.deliver_reset_password_instructions!
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      mail = ActionMailer::Base.deliveries.last

      expect(mail.to).to include(user.email)
      expect(mail.subject).to eq(I18n.t('defaults.password_reset'))

      decoded_body = if mail.text_part
                        mail.text_part.body.decoded
                     else
                        mail.body.decoded
                     end
      expect(decoded_body).to include(user.reset_password_token)
    end
  end
end
