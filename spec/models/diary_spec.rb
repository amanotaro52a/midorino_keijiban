require 'rails_helper'

RSpec.describe Diary, type: :model do
  let(:user) { create(:user) }
  let(:diary) { build(:diary, user: user) }

  describe 'バリデーションのテスト' do
    context '正常系' do
      it '全ての属性が有効な場合、Diaryは有効であること' do
        expect(diary).to be_valid
      end
    end

    context '異常系' do
      it 'titleが空の場合、無効であること' do
        diary.title = nil
        expect(diary).not_to be_valid
        expect(diary.errors[:title]).to include('を入力してください')
      end

      it 'titleが255文字を超える場合、無効であること' do
        diary.title = 'a' * 256
        expect(diary).not_to be_valid
        expect(diary.errors[:title]).to include('は255文字以内で入力してください')
      end

      it 'summary_contentが空の場合、無効であること' do
        diary.summary_content = nil
        expect(diary).not_to be_valid
        expect(diary.errors[:summary_content]).to include('を入力してください')
      end

      it 'summary_contentが65535文字を超える場合、無効であること' do
        diary.summary_content = 'a' * 65_536
        expect(diary).not_to be_valid
        expect(diary.errors[:summary_content]).to include('は65535文字以内で入力してください')
      end

      it 'plant_nameが空の場合、無効であること' do
        diary.plant_name = nil
        expect(diary).not_to be_valid
        expect(diary.errors[:plant_name]).to include('を入力してください')
      end

      it 'variety_nameが100文字を超える場合、無効であること' do
        diary.variety_name = 'a' * 101
        expect(diary).not_to be_valid
        expect(diary.errors[:variety_name]).to include('は100文字以内で入力してください')
      end

      it 'cultivation_methodが50文字を超える場合、無効であること' do
        diary.cultivation_method = 'a' * 51
        expect(diary).not_to be_valid
        expect(diary.errors[:cultivation_method]).to include('は50文字以内で入力してください')
      end

      it 'cultivation_locationが50文字を超える場合、無効であること' do
        diary.cultivation_location = 'a' * 51
        expect(diary).not_to be_valid
        expect(diary.errors[:cultivation_location]).to include('は50文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it 'Userに属していること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'GrowthStagesを持っていること' do
      association = described_class.reflect_on_association(:growth_stages)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'クラスメソッドのテスト' do
    describe '.ransackable_attributes' do
      it 'ransackで検索可能な属性を返すこと' do
        expect(Diary.ransackable_attributes).to include('title', 'summary_content', 'plant_name', 'variety_name', 'cultivation_method', 'cultivation_location')
      end
    end

    describe '.ransackable_associations' do
      it 'ransackで検索可能なアソシエーションを返すこと' do
        expect(Diary.ransackable_associations).to include('user')
      end
    end
  end
end
