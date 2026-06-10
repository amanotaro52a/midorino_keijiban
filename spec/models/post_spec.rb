require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { build(:post, user: user) }

  describe 'バリデーションのテスト' do
    context '正常系' do
      it '全ての属性が有効な場合、Postは有効であること' do
        expect(post).to be_valid
      end
    end

    context '異常系' do
      it 'titleが空の場合、無効であること' do
        post.title = nil
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('を入力してください')
      end

      it 'titleが255文字を超える場合、無効であること' do
        post.title = 'a' * 256
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('は255文字以内で入力してください')
      end

      it 'bodyが65535文字を超える場合、無効であること' do
        post.body = 'a' * 65_536
        expect(post).not_to be_valid
        expect(post.errors[:body]).to include('は65535文字以内で入力してください')
      end

      it 'plant_nameが100文字を超える場合、無効であること' do
        post.plant_name = 'a' * 101
        expect(post).not_to be_valid
        expect(post.errors[:plant_name]).to include('は100文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it 'Userに属していること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'クラスメソッドのテスト' do
    describe '.ransackable_attributes' do
      it 'ransackで検索可能な属性を返すこと' do
        expect(Post.ransackable_attributes).to include('title', 'body', 'plant_name')
      end
    end

    describe '.ransackable_associations' do
      it 'ransackで検索可能なアソシエーションを返すこと' do
        expect(Post.ransackable_associations).to include('user')
      end
    end
  end
end
