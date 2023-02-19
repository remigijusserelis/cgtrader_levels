# frozen_string_literal: true

module CgtraderLevels
  class User < ActiveRecord::Base
    belongs_to :level

    after_commit :set_new_level, if: :should_set_new_level?

    private

    def set_new_level
      ApplyLevels.call(self, reputation)
    end

    def should_set_new_level?
      level.nil? || saved_change_to_reputation?
    end
  end
end
