# frozen_string_literal: true

describe CgtraderLevels::User do
  subject(:user) { described_class.create! }
  let!(:level1) { CgtraderLevels::Level.create!(experience: 0, title: 'First level', rewards: []) }
  let!(:level2) { CgtraderLevels::Level.create!(experience: 10, title: 'Second level', rewards: [reward_10_coins]) }
  let!(:level3) { CgtraderLevels::Level.create!(experience: 13, title: 'Third level', rewards: [reward_reduce_5_tax]) }
  let(:reward_10_coins) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 10) }
  let(:reward_reduce_5_tax) { CgtraderLevels::Reward.create( reward_type: :tax_reduction, amount: 5) }

  context 'with new user' do
    it 'has 0 reputation points' do
      expect(user.reputation).to eq(0)
    end

    it "has assigned 'First level'" do
      expect(user.level).to eq(level1)
    end
  end

  context 'when leveling up' do
    it "level ups from 'First level' to 'Second level'" do
      expect {
        user.update_attribute(:reputation, 10)
      }.to change { user.reload.level }.from(level1).to(level2)
    end

    it "level ups from 'First level' to 'Second level'" do
      expect {
        user.update_attribute(:reputation, 11)
      }.to change { user.reload.level }.from(level1).to(level2)
    end
  end

  describe 'level up bonuses & privileges' do
    it 'gives 10 coins to user' do
      expect {
        user.update_attribute(:reputation, 10)
      }.to change { user.reload.coins }.from(0).to(10)
    end

    it 'reduces 5 tax' do
      expect {
        user.update_attribute(:reputation, 15)
      }.to change { user.reload.tax }.from(30).to(25)
    end
  end
end
