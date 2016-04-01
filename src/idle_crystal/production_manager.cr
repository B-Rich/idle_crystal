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

  def build(building : IdleCrystal::Production::ProductionBuilding)
    cost_for_next = building.cost_for_next

    if @resource_manager.resources_pack > cost_for_next
      @resource_manager.resources_pack.remove(cost_for_next)
      building.build

      return true
    else
      return false
    end
  end

  def next_tick
    @resource_manager.tick_start
    @resources.values.each do |r|
      @resource_manager.add_from_production( r.produce )
    end
  end
end
