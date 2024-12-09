require 'rails_helper'

RSpec.describe "Diaries", type: :request do
  let(:user) { create(:user) }
  let(:diary) { create(:diary, user: user) }

  before do
    # ユーザーでログイン
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /diaries" do
    it "一覧ページが正常に表示される" do
      get diaries_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /diaries/:id" do
    it "詳細ページが正常に表示される" do
      get diary_path(diary)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /diaries" do
    it "新しい日記が作成される" do
      expect {
        post diaries_path, params: { diary: {
          title: "New Diary",
          summary_content: "This is a new diary summary.",
          plant_name: "Tomato",
          user_id: user.id
        } }
      }.to change(Diary, :count).by(1)
    end    
  end

  describe "PUT /diaries/:id" do
    it "日記が更新される" do
      put diary_path(diary), params: { diary: { title: "Updated Title" } }
      expect(diary.reload.title).to eq("Updated Title")
      expect(response).to redirect_to(diary_path(diary))
    end
  end

  describe "DELETE /diaries/:id" do
    it "日記が削除される" do
      delete diary_path(diary)
      expect(Diary.exists?(diary.id)).to be_falsey
      expect(response).to redirect_to(diaries_path)
    end
  end
end
