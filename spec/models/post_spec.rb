require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { build(:post, user: user) }

  describe 'バリデーション' do
    context "有効な属性の場合" do
      it "全ての属性が有効であること" do
        expect(post).to be_valid
      end
    end

    context "title" do
      it "nil の場合、無効であること" do
        post.title = nil
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('を入力してください')
      end

      it "255文字を超える場合、無効であること" do
        post.title = 'a' * 256
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('は255文字以内で入力してください')
      end

      it "255文字の場合、有効であること" do
        post.title = 'a' * 255
        expect(post).to be_valid
      end
    end

    context "body" do
      # body に presence バリデーションがないため nil は有効
      it "nil の場合、有効であること" do
        post.body = nil
        expect(post).to be_valid
      end

      it "65535文字を超える場合、無効であること" do
        post.body = 'a' * 65_536
        expect(post).not_to be_valid
        expect(post.errors[:body]).to include('は65535文字以内で入力してください')
      end

      it "65535文字の場合、有効であること" do
        post.body = 'a' * 65_535
        expect(post).to be_valid
      end
    end

    context "plant_name" do
      # plant_name に presence バリデーションがないため nil は有効
      it "nil の場合、有効であること" do
        post.plant_name = nil
        expect(post).to be_valid
      end

      it "100文字を超える場合、無効であること" do
        post.plant_name = 'a' * 101
        expect(post).not_to be_valid
        expect(post.errors[:plant_name]).to include('は100文字以内で入力してください')
      end

      it "100文字の場合、有効であること" do
        post.plant_name = 'a' * 100
        expect(post).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it "User に属していること" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "user が nil の場合、無効であること" do
      post.user = nil
      expect(post).not_to be_valid
    end
  end

  describe 'クラスメソッド' do
    describe '.ransackable_attributes' do
      it "title / body / plant_name が含まれること" do
        expect(Post.ransackable_attributes).to include('title', 'body', 'plant_name')
      end
    end

    describe '.ransackable_associations' do
      it "user が含まれること" do
        expect(Post.ransackable_associations).to include('user')
      end
    end
  end
end
