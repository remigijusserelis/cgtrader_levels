# frozen_string_literal: true

describe CgtraderLevels::ApplyLevels do
  subject { described_class.call(user, reputation) }
  let(:user) { CgtraderLevels::User.create!(coins: 0, tax: 30, level: level1) }
  let(:reputation) { 0 }
  let!(:level1) { CgtraderLevels::Level.create!(experience: 0, title: 'First level', rewards: []) }
  let!(:level2) do
    CgtraderLevels::Level.create!(
      experience: 10,
      title: 'Second level',
      rewards: [reward_10_coins, reward_reduce_5_tax]
    )
  end
  let!(:level3) do
    CgtraderLevels::Level.create!(
      experience: 25,
      title: 'Third level',
      rewards: [reward_10_coins, reward_reduce_5_tax]
    )
  end
  let(:reward_10_coins) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 15) }
  let(:reward_reduce_5_tax) { CgtraderLevels::Reward.create( reward_type: :tax_reduction, amount: 10) }

  context 'with enough reputation to level 2' do
    let(:reputation) { 15 }

    it 'changes level to level2' do
      expect {
        subject
      }.to change { user.reload.level }.from(level1).to(level2)
    end

    it 'gives 10 coins' do
      expect {
        subject
      }.to change { user.reload.coins }.from(0).to(10)
    end

    it 'reducs tax by 5' do
      expect {
        subject
      }.to change { user.reload.tax }.from(30).to(25)
    end
  end

  context 'with enough reputation for to level 3' do
    let(:reputation) { 30 }

    it 'changes level to level3' do
      expect {
        subject
      }.to change { user.reload.level }.from(level1).to(level3)
    end

    it 'gives 25 coins total' do
      expect {
        subject
      }.to change { user.reload.coins }.from(0).to(25)
    end

    it 'reducs tax by 15 total' do
      expect {
        subject
      }.to change { user.reload.tax }.from(30).to(15)
    end
  end

  context 'with not enough reputation to level 2' do
    let(:reputation) { 5 }

    it 'keeps at level1' do
      expect {
        subject
      }.to_not change { user.reload.level }.from(level1)
    end

    it 'keeps coins' do
      expect {
        subject
      }.to_not change { user.reload.coins }.from(0)
    end

    it 'keeps tax' do
      expect {
        subject
      }.to_not change { user.reload.tax }.from(30)
    end
  end
end
