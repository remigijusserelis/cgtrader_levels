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
      matching_level = Level.where(experience: ..reputation).order(experience: :desc).first

      return unless matching_level
      return if user.level == matching_level

      user.update(level: matching_level)
    end

    private

    def reputation_in_cents
      reputation * 100
    end

    attr_reader :user, :reputation
  end
end
