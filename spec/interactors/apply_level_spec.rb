# frozen_string_literal: true

describe CgtraderLevels::ApplyLevels do
  subject { described_class.call(user, reputation) }
  let(:user) { CgtraderLevels::User.create!(coins: 0, tax: 30, level: level1) }
  let(:reputation) { 0 }
  let!(:level1) { CgtraderLevels::Level.create!(experience: 0, title: 'First level', rewards: []) }
  let!(:level2) { CgtraderLevels::Level.create!(experience: 10, title: 'Second level', rewards: [reward_10_coins]) }
  let(:reward_10_coins) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 10) }

  context 'with enough reputation to level 2' do
    let(:reputation) { 15 }

    it 'changes level to level2' do
      expect {
        subject
      }.to change { user.reload.level }.from(level1).to(level2)
    end
  end

  context 'with not enough reputation to level 2' do
    let(:reputation) { 5 }

    it 'keeps at level1' do
      expect {
        subject
      }.to_not change { user.reload.level }.from(level1)
    end
  end
end
