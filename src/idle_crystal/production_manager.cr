require "./production/abstract"
require "./production/food"
require "./production/wood"
require "yaml"

class IdleCrystal::ProductionManager
  def initialize(rm)
    @resource_manager = rm
    @food = IdleCrystal::Production::Food.new
    @wood = IdleCrystal::Production::Wood.new
  end

  getter :food, :wood

  YAML.mapping({
    food: IdleCrystal::Production::Food,
    wood: IdleCrystal::Production::Wood,
  })
end
