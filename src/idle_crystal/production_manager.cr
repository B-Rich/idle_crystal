require "./production/abstract"
require "./production/food"
require "./production/wood"
require "yaml"

class IdleCrystal::ProductionManager
  def initialize(rm)
    @resource_manager = rm
    @resources = {
      "food" => IdleCrystal::Production::Food.new,
      "wood" => IdleCrystal::Production::Wood.new
    }
  end

  getter :resources
end
