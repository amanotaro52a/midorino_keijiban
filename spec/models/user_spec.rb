require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) } # FactoryBotを使ってUserのインスタンスを生成

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
      create(:user, email: 'test@example.com') # 既存ユーザーを作成
      user.email = 'test@example.com'
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it 'メールアドレスが大文字小文字の違いだけの場合、無効であること' do
      # まず通常のメールアドレスを持つユーザーを作成
      user1 = create(:user, email: 'testuser@example.com')
      
      # 次に新しいユーザーを作成し、同じメールアドレスを大文字小文字を変えて設定
      user2 = build(:user, email: 'TESTUSER@EXAMPLE.COM')
    
      # user2が無効であることを確認
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
    before { ActiveJob::Base.queue_adapter = :test } # テスト用のジョブアダプタを設定

    it 'パスワードリセットメールが送信されること' do
      # メール送信をトリガー
      expect {
        user.deliver_reset_password_instructions!
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob).on_queue('default')

      # メールが正しく生成されているかを確認
      perform_enqueued_jobs do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        mail = ActionMailer::Base.deliveries.last

        expect(mail.to).to include(user.email)
        expect(mail.subject).to eq(I18n.t('defaults.password_reset'))
      end
    end
  end
end
