# frozen_string_literal: true

module CgtraderLevels
  class Level < ActiveRecord::Base
    has_many :users
    has_and_belongs_to_many :rewards
  end
end
