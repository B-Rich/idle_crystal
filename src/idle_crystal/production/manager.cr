require "./resource"
require "yaml"

class IdleCrystal::Production::Manager
  RESOURCES_LIST_PATH = File.join(["data", "resources_list.yml"])

  def initialize(rm)
    @resource_manager = rm
    @resource_names = Array(String).new
    YAML.parse(File.read(RESOURCES_LIST_PATH)).as_a.each do |r|
      @resource_names << r.to_s
    end

    @resources = Hash(String, IdleCrystal::Production::Resource).new

    @resource_names.each do |name|
      @resources[name] = IdleCrystal::Production::Resource.new(name)
    end
  end

  getter :resources, :resource_manager

  def build(building : IdleCrystal::Production::Building)
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
