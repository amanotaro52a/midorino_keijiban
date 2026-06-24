require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user, email: "other@example.com") }
  let!(:my_post)    { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  # posts_controller.rb の実装を踏まえた修正点:
  # - index アクションは存在しないため削除
  # - show は skip_before_action のため未ログインでもアクセス可能
  # - create 成功後は root_path へリダイレクト
  # - edit/update/destroy で他ユーザーの投稿は current_user.posts.find_by で nil になり
  #   posts_path へリダイレクト（root_path ではない）

  # ----------------------------------------
  # GET #show（skip_before_action のため未ログインでもアクセス可能）
  # ----------------------------------------
  describe "GET #show" do
    context "未ログインの場合" do
      it "200 OK を返すこと" do
        get :show, params: { id: my_post.id }
        expect(response).to have_http_status(:ok)
      end

      it ":show テンプレートを描画すること" do
        get :show, params: { id: my_post.id }
        expect(response).to render_template(:show)
      end
    end

    context "ログイン済みの場合" do
      before { login_user(user) }

      it "200 OK を返すこと" do
        get :show, params: { id: my_post.id }
        expect(response).to have_http_status(:ok)
      end

      it "@post に対象の投稿が格納されること" do
        get :show, params: { id: my_post.id }
        expect(assigns(:post)).to eq(my_post)
      end
    end

    context "存在しない投稿 ID の場合" do
      before { login_user(user) }

      it "posts_path へリダイレクトすること" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  # ----------------------------------------
  # GET #new
  # ----------------------------------------
  describe "GET #new" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before { login_user(user) }

      it ":new テンプレートを描画すること" do
        get :new
        expect(response).to render_template(:new)
      end

      it "@post に新規 Post オブジェクトが格納されること" do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end
  end

  # ----------------------------------------
  # POST #create
  # ----------------------------------------
  describe "POST #create" do
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
        post :create, params: valid_params
        expect(response).to redirect_to(login_path)
      end

      it "投稿が作成されないこと" do
        expect {
          post :create, params: valid_params
        }.not_to change(Post, :count)
      end
    end

    context "ログイン済みの場合（有効なパラメータ）" do
      before { login_user(user) }

      it "投稿が作成されること" do
        expect {
          post :create, params: valid_params
        }.to change(Post, :count).by(1)
      end

      # create 成功後は root_path へリダイレクト
      it "ルートページへリダイレクトすること" do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        post :create, params: valid_params
        expect(flash[:success]).to be_present
      end

      it "投稿がログインユーザーに紐づくこと" do
        post :create, params: valid_params
        expect(Post.last.user).to eq(user)
      end
    end

    context "ログイン済みの場合（無効なパラメータ）" do
      before { login_user(user) }

      it "投稿が作成されないこと" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Post, :count)
      end

      it ":new テンプレートを再描画すること" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end

      it "422 を返すこと" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # ----------------------------------------
  # GET #edit
  # ----------------------------------------
  describe "GET #edit" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get :edit, params: { id: my_post.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合（投稿の本人）" do
      before { login_user(user) }

      it ":edit テンプレートを描画すること" do
        get :edit, params: { id: my_post.id }
        expect(response).to render_template(:edit)
      end

      it "@post に対象の投稿が格納されること" do
        get :edit, params: { id: my_post.id }
        expect(assigns(:post)).to eq(my_post)
      end
    end

    context "ログイン済みの場合（他ユーザーの投稿）" do
      before { login_user(user) }

      # current_user.posts.find_by で nil になるため posts_path へリダイレクト
      it "posts_path へリダイレクトすること" do
        get :edit, params: { id: other_post.id }
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  # ----------------------------------------
  # PATCH #update
  # ----------------------------------------
  describe "PATCH #update" do
    let(:valid_params)   { { id: my_post.id, post: { title: "Updated Title" } } }
    let(:invalid_params) { { id: my_post.id, post: { title: "" } } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        patch :update, params: valid_params
        expect(response).to redirect_to(login_path)
      end

      it "投稿が更新されないこと" do
        patch :update, params: valid_params
        expect(my_post.reload.title).not_to eq("Updated Title")
      end
    end

    context "ログイン済みの場合（投稿の本人・有効なパラメータ）" do
      before { login_user(user) }

      it "投稿が更新されること" do
        patch :update, params: valid_params
        expect(my_post.reload.title).to eq("Updated Title")
      end

      it "投稿詳細ページへリダイレクトすること" do
        patch :update, params: valid_params
        expect(response).to redirect_to(post_path(my_post))
      end

      it "成功のフラッシュメッセージが表示されること" do
        patch :update, params: valid_params
        expect(flash[:success]).to be_present
      end
    end

    context "ログイン済みの場合（投稿の本人・無効なパラメータ）" do
      before { login_user(user) }

      it "投稿が更新されないこと" do
        patch :update, params: invalid_params
        expect(my_post.reload.title).not_to eq("")
      end

      it ":edit テンプレートを再描画すること" do
        patch :update, params: invalid_params
        expect(response).to render_template(:edit)
      end

      it "422 を返すこと" do
        patch :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "ログイン済みの場合（他ユーザーの投稿）" do
      before { login_user(user) }

      # current_user.posts.find で ActiveRecord::RecordNotFound が発生する
      # アプリ側で rescue_from 等の処理がなければ 404 になる
      it "ActiveRecord::RecordNotFound が発生すること" do
        expect {
          patch :update, params: { id: other_post.id, post: { title: "Updated Title" } }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # ----------------------------------------
  # DELETE #destroy
  # ----------------------------------------
  describe "DELETE #destroy" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        delete :destroy, params: { id: my_post.id }
        expect(response).to redirect_to(login_path)
      end

      it "投稿が削除されないこと" do
        expect {
          delete :destroy, params: { id: my_post.id }
        }.not_to change(Post, :count)
      end
    end

    context "ログイン済みの場合（投稿の本人）" do
      before { login_user(user) }

      it "投稿が削除されること" do
        expect {
          delete :destroy, params: { id: my_post.id }
        }.to change(Post, :count).by(-1)
      end

      it "ルートページへリダイレクトすること" do
        delete :destroy, params: { id: my_post.id }
        expect(response).to redirect_to(root_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        delete :destroy, params: { id: my_post.id }
        expect(flash[:success]).to be_present
      end
    end

    context "ログイン済みの場合（他ユーザーの投稿）" do
      before { login_user(user) }

      # current_user.posts.find で ActiveRecord::RecordNotFound が発生する
      it "ActiveRecord::RecordNotFound が発生すること" do
        expect {
          delete :destroy, params: { id: other_post.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
