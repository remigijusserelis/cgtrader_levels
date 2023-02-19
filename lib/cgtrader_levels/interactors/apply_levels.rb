# frozen_string_literal: true

module CgtraderLevels
  class ApplyLevels
    def self.call(user, reputation)
      new(user, reputation).call
    end

    def initialize(user, reputation)
      @user = user
      @reputation = reputation
    end

    def call
      new_level = Level.where(experience: ..reputation).order(experience: :desc).first

      return unless new_level
      return if user.level == new_level

      byebug

      user.transaction do
        user.coins += total_bonus_coins
        user.tax -= total_tax_reduction
        user.level = new_level
        user.save!
      end
    end

    private

    def total_bonus_coins
      rewards.bonus_coins.sum(:amount).presence || 0
    end

    def total_tax_reduction
      rewards.tax_reduction.sum(:amount).presence || 0
    end

    def rewards
      @rewards ||= Reward.includes(:levels).where(levels: { experience: user.level.experience..reputation })
    end

    attr_reader :user, :reputation
  end
end
