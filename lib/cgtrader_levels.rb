# frozen_string_literal: true

require 'cgtrader_levels/version'

module CgtraderLevels
  autoload :User, 'cgtrader_levels/models/user'
  autoload :Level, 'cgtrader_levels/models/level'
  autoload :Reward, 'cgtrader_levels/models/reward'
  autoload :ApplyLevels, 'cgtrader_levels/interactors/apply_levels'
end
