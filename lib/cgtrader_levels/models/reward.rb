# frozen_string_literal: true

module CgtraderLevels
  class Reward < ActiveRecord::Base
    TYPES = {
      bonus_coins: 'bonus_coins',
      tax_reduction: 'tax_reduction'
    }

    enum reward_type: TYPES

    has_and_belongs_to_many :levels

    validates :reward_type, inclusion: { in: TYPES.values }
  end
end
