require 'rails_helper'

RSpec.describe GrowthStage, type: :model do
  let(:diary) { create(:diary) }

  describe 'バリデーション' do
    it '有効なGrowthStageを持つ場合、有効であること' do
      growth_stage = build(:growth_stage, diary: diary, growth_stage_contents: "Valid contents")
      expect(growth_stage).to be_valid
    end

    it 'growth_stage_contentsが空の場合、無効であること' do
      growth_stage = build(:growth_stage, diary: diary, growth_stage_contents: nil)
      expect(growth_stage).to be_invalid
    end

    it 'imageが空の場合、無効であること' do
      growth_stage = build(:growth_stage, diary: diary, growth_stage_contents: "Valid contents", image: nil)
      expect(growth_stage).to be_invalid
    end
  end
end

