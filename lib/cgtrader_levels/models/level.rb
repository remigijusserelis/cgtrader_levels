# frozen_string_literal: true

module CgtraderLevels
  class Level < ActiveRecord::Base
    has_many :users
  end
end
