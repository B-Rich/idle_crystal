require "./production/abstract"
require "./production/food"
require "./production/wood"
require "./production/work_force"
require "yaml"

class IdleCrystal::ProductionManager
  def initialize(rm)
    @resource_manager = rm
    @resources = {
      "food" => IdleCrystal::Production::Food.new,
      "wood" => IdleCrystal::Production::Wood.new,
      "work_force" => IdleCrystal::Production::WorkForce.new,
    }
  end

  getter :resources, :resource_manager

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
