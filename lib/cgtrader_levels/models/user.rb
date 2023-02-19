# frozen_string_literal: true

module CgtraderLevels
  class User < ActiveRecord::Base
    belongs_to :level

    after_commit :set_new_level, if: :should_set_new_level?

    private

    def set_new_level
      matching_level = Level.where(experience: ..reputation).order(experience: :desc).first

      return unless matching_level
      return if level == matching_level

      update(level: matching_level)
    end

    def should_set_new_level?
      level.nil? || saved_change_to_reputation?
    end
  end
end
