# frozen_string_literal: true

describe CgtraderLevels::User do
  subject(:user) { described_class.create! }
  let!(:level1) { CgtraderLevels::Level.create!(experience: 0, title: 'First level', rewards: [reward_bonus_1_coin]) }
  let!(:level2) { CgtraderLevels::Level.create!(experience: 10, title: 'Second level', rewards: [reward_bonus_7_coins]) }
  let!(:level3) { CgtraderLevels::Level.create!(experience: 13, title: 'Third level') }
  let(:reward_bonus_1_coin) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 1) }
  let(:reward_bonus_7_coins) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 7) }

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
    it 'gives 7 coins to user' do

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.coins }.from(1).to(8)
    end

    it 'reduces tax rate by 1'
  end
end
