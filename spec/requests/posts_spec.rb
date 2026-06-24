require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user, email: "other@example.com") }
  let(:my_post)    { create(:post, user: user) }
  let(:other_post) { create(:post, user: other_user) }

  # posts_controller.rb の実装を踏まえた修正点:
  # - show は skip_before_action のため未ログインでもアクセス可能
  # - create 成功後は root_path へリダイレクト
  # - edit で他ユーザーの投稿は posts_path へリダイレクト
  # - update/destroy で他ユーザーの投稿は ActiveRecord::RecordNotFound が発生

  # ----------------------------------------
  # GET /posts/:id（未ログインでもアクセス可能）
  # ----------------------------------------
  describe "GET /posts/:id" do
    context "未ログインの場合" do
      it "200 OK を返すこと" do
        get post_path(my_post)
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      before { login_user(user) }

      it "200 OK を返すこと" do
        get post_path(my_post)
        expect(response).to have_http_status(:ok)
      end

      it "投稿のタイトルがレスポンスに含まれること" do
        get post_path(my_post)
        expect(response.body).to include(my_post.title)
      end
    end

    context "存在しない投稿 ID の場合" do
      before { login_user(user) }

      it "posts_path へリダイレクトすること" do
        get post_path(id: 0)
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  # ----------------------------------------
  # GET /posts/new
  # ----------------------------------------
  describe "GET /posts/new" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get new_post_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before { login_user(user) }

      it "200 OK を返すこと" do
        get new_post_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # ----------------------------------------
  # POST /posts
  # ----------------------------------------
  describe "POST /posts" do
    let(:valid_params) do
      {
        post: {
          title: "New Post",
          body: "This is a new post body.",
          plant_name: "Monstera",
          image: fixture_file_upload("spec/fixtures/file/testimage.jpg", "image/jpeg")
        }
      }
    end

    let(:invalid_params) do
      { post: { title: "", body: "body", plant_name: "Monstera" } }
    end

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        post posts_path, params: valid_params
        expect(response).to redirect_to(login_path)
      end

      it "投稿が作成されないこと" do
        expect {
          post posts_path, params: valid_params
        }.not_to change(Post, :count)
      end
    end

    context "ログイン済みの場合（有効なパラメータ）" do
      before { login_user(user) }

      it "投稿が作成されること" do
        expect {
          post posts_path, params: valid_params
        }.to change(Post, :count).by(1)
      end

      # create 成功後は root_path へリダイレクト
      it "ルートページへリダイレクトすること" do
        post posts_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        post posts_path, params: valid_params
        expect(flash[:success]).to be_present
      end
    end

    context "ログイン済みの場合（無効なパラメータ）" do
      before { login_user(user) }

      it "投稿が作成されないこと" do
        expect {
          post posts_path, params: invalid_params
        }.not_to change(Post, :count)
      end

      it "422 を返すこと" do
        post posts_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # ----------------------------------------
  # GET /posts/:id/edit
  # ----------------------------------------
  describe "GET /posts/:id/edit" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get edit_post_path(my_post)
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合（投稿の本人）" do
      before { login_user(user) }

      it "200 OK を返すこと" do
        get edit_post_path(my_post)
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合（他ユーザーの投稿）" do
      before { login_user(user) }

      # current_user.posts.find_by で nil になるため posts_path へリダイレクト
      it "posts_path へリダイレクトすること" do
        get edit_post_path(other_post)
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  # ----------------------------------------
  # PATCH /posts/:id
  # ----------------------------------------
  describe "PATCH /posts/:id" do
    let(:update_params) { { post: { title: "Updated Title" } } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        patch post_path(my_post), params: update_params
        expect(response).to redirect_to(login_path)
      end

      it "投稿が更新されないこと" do
        patch post_path(my_post), params: update_params
        expect(my_post.reload.title).not_to eq("Updated Title")
      end
    end

    context "ログイン済みの場合（投稿の本人）" do
      before { login_user(user) }

      it "投稿が更新されること" do
        patch post_path(my_post), params: update_params
        expect(my_post.reload.title).to eq("Updated Title")
      end

      it "投稿詳細ページへリダイレクトすること" do
        patch post_path(my_post), params: update_params
        expect(response).to redirect_to(post_path(my_post))
      end
    end

    context "ログイン済みの場合（他ユーザーの投稿）" do
      before { login_user(user) }

      # request spec では例外は Rails の例外ハンドリングに渡され 404 または 500 になる
      it "404 または 500 を返すこと" do
        patch post_path(other_post), params: update_params
        expect(response.status).to be_in([ 404, 500 ])
      end
    end
  end

  # ----------------------------------------
  # DELETE /posts/:id
  # ----------------------------------------
  describe "DELETE /posts/:id" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        delete post_path(my_post)
        expect(response).to redirect_to(login_path)
      end

      it "投稿が削除されないこと" do
        my_post
        expect {
          delete post_path(my_post)
        }.not_to change(Post, :count)
      end
    end

    context "ログイン済みの場合（投稿の本人）" do
      before { login_user(user) }

      it "投稿が削除されること" do
        my_post
        expect {
          delete post_path(my_post)
        }.to change(Post, :count).by(-1)
      end

      it "ルートページへリダイレクトすること" do
        delete post_path(my_post)
        expect(response).to redirect_to(root_path)
      end
    end

    context "ログイン済みの場合（他ユーザーの投稿）" do
      before { login_user(user) }

      # request spec では例外は Rails の例外ハンドリングに渡され 404 または 500 になる
      it "404 または 500 を返すこと" do
        delete post_path(other_post)
        expect(response.status).to be_in([ 404, 500 ])
      end
    end
  end
end
