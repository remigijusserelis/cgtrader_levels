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
      rewards: [reward_15_coins, reward_reduce_10_tax]
    )
  end
  let(:reward_10_coins) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 10) }
  let(:reward_15_coins) { CgtraderLevels::Reward.create( reward_type: :bonus_coins, amount: 15) }
  let(:reward_reduce_5_tax) { CgtraderLevels::Reward.create( reward_type: :tax_reduction, amount: 5) }
  let(:reward_reduce_10_tax) { CgtraderLevels::Reward.create( reward_type: :tax_reduction, amount: 10) }

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

    it 'reduces tax by 5' do
      expect {
        subject
      }.to change { user.reload.tax }.from(30).to(25)
    end

    context 'when tax reduction is higher than current tax' do
      let!(:level2) do
        CgtraderLevels::Level.create!(
          experience: 10,
          title: 'Second level',
          rewards: [reward_reduce_50_tax]
        )
      end
      let(:reward_reduce_50_tax) { CgtraderLevels::Reward.create( reward_type: :tax_reduction, amount: 50) }

      it 'reduces tax to' do
        expect {
          subject
        }.to change { user.reload.tax }.from(30).to(0)
      end
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

    context 'from level 2' do
      let(:user) { CgtraderLevels::User.create!(coins: 10, tax: 25, level: level2) }

      it 'changes level to level3' do
        expect {
          subject
        }.to change { user.reload.level }.from(level2).to(level3)
      end

      it 'gives 25 coins total' do
        expect {
          subject
        }.to change { user.reload.coins }.from(10).to(25)
      end

      it 'reducs tax by 15 total' do
        expect {
          subject
        }.to change { user.reload.tax }.from(25).to(15)
      end
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
