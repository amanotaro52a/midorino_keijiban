require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    context "有効な属性の場合" do
      it "有効であること" do
        expect(user).to be_valid
      end
    end

    context "name" do
      it "nil の場合、無効であること" do
        user.name = nil
        expect(user).to_not be_valid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "255文字を超える場合、無効であること" do
        user.name = 'a' * 256
        expect(user).to_not be_valid
        expect(user.errors[:name]).to include("は255文字以内で入力してください")
      end

      it "255文字の場合、有効であること" do
        user.name = 'a' * 255
        expect(user).to be_valid
      end
    end

    context "email" do
      it "nil の場合、無効であること" do
        user.email = nil
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("を入力してください")
      end

      it "重複する場合、無効であること" do
        create(:user, email: 'duplicate@example.com')
        user.email = 'duplicate@example.com'
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("はすでに存在します")
      end

      it "大文字小文字の違いのみの重複でも無効であること" do
        create(:user, email: 'testuser@example.com')
        user2 = build(:user, email: 'TESTUSER@EXAMPLE.COM')
        expect(user2).to_not be_valid
        expect(user2.errors[:email]).to include("はすでに存在します")
      end

      # email フォーマットバリデーションがモデルにない場合はこのテストを削除する
      # it "不正な形式の場合、無効であること" do
      #   user.email = 'invalid-email'
      #   expect(user).to_not be_valid
      # end
    end

    context "password" do
      it "3文字未満の場合、無効であること" do
        user.password = '12'
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include("は3文字以上で入力してください")
      end

      it "確認用パスワードと一致しない場合、無効であること" do
        user.password = 'password'
        user.password_confirmation = 'different'
        expect(user).to_not be_valid
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end
  end

  describe 'アソシエーション' do
    it "複数の投稿を持てること" do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end

    it "ユーザー削除時に関連する投稿も削除されること" do
      create(:post, user: user)
      expect { user.destroy }.to change(Post, :count).by(-1)
    end
  end

  describe 'パスワードリセット' do
    before { ActionMailer::Base.deliveries.clear }

    it "パスワードリセットメールが送信されること" do
      perform_enqueued_jobs do
        expect {
          user.deliver_reset_password_instructions!
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(user.email)
      expect(mail.subject).to eq(I18n.t('defaults.password_reset'))
    end

    it "メール本文にリセットトークンが含まれること" do
      perform_enqueued_jobs do
        user.deliver_reset_password_instructions!
      end

      user.reload
      mail = ActionMailer::Base.deliveries.last
      decoded_body = mail.text_part ? mail.text_part.body.decoded : mail.body.decoded
      expect(decoded_body).to include(user.reset_password_token)
    end
  end
end
