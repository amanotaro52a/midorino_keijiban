require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    # top アクションは skip_before_action :require_login のため
    # 未ログインでもアクセス可能で全投稿が表示される

    context "投稿が存在する場合" do
      let(:user)     { create(:user) }
      let!(:my_post) { create(:post, user: user) }

      it "200 OK を返すこと" do
        get root_path
        expect(response).to have_http_status(:ok)
      end

      it "投稿へのリンクがレスポンスに含まれること" do
        get root_path
        expect(response.body).to include(post_path(my_post))
      end

      it "投稿の画像URLがレスポンスに含まれること" do
        get root_path
        expect(response.body).to include(my_post.image_url)
      end
    end

    context "投稿が存在しない場合" do
      it "200 OK を返すこと" do
        get root_path
        expect(response).to have_http_status(:ok)
      end

      it "「投稿はまだありません」が表示されること" do
        get root_path
        expect(response.body).to include('投稿はまだありません')
      end
    end
  end
end
