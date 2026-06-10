require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:my_post) { create(:post, user: user) }

  before do
    # ユーザーでログイン
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /posts" do
    it "一覧ページが正常に表示される" do
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /posts/:id" do
    it "詳細ページが正常に表示される" do
      get post_path(my_post)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    it "新しい投稿が作成される" do
      expect {
        post posts_path, params: { post: {
          title: "New Post",
          body: "This is a new post body.",
          plant_name: "Monstera",
          user_id: user.id,
          image: fixture_file_upload("spec/fixtures/file/testimage.jpg", "image/jpeg")
        } }
      }.to change(Post, :count).by(1)
    end
  end

  describe "PUT /posts/:id" do
    it "投稿が更新される" do
      put post_path(my_post), params: { post: { title: "Updated Title" } }
      expect(my_post.reload.title).to eq("Updated Title")
      expect(response).to redirect_to(post_path(my_post))
    end
  end

  describe "DELETE /posts/:id" do
    it "投稿が削除される" do
      delete post_path(my_post)
      expect(Post.exists?(my_post.id)).to be_falsey
      expect(response).to redirect_to(posts_path)
    end
  end
end
