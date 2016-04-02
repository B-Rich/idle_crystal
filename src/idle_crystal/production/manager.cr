require "./resource"
require "yaml"

# Store all types of resources and perform production
class IdleCrystal::Production::Manager
  RESOURCES_LIST_PATH = File.join(["data", "resources_list.yml"])
  SAVE_FILE_PATH = File.join(["save", "production.yml"])

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

  def save_key(name, b_name)
    "#{name}::#{b_name}"
  end

  def save
    h = Hash(String, Int32).new
    @resource_names.each do |name|
      @resources[name].buildings.each do |b|
        h[save_key(name, b.name)] = b.amount
      end
    end

    File.open(SAVE_FILE_PATH, "w") { |f| YAML.dump(h, f) }
  end

  def load
    return unless File.exists?(SAVE_FILE_PATH)
    h = YAML.parse(File.read(SAVE_FILE_PATH)).as_h

    @resource_names.each do |name|
      @resources[name].buildings.each do |b|
        k = save_key(name, b.name)
        if h.has_key?(k)
          amount = h[k].to_s.to_i
          b.amount_from_load(amount)
        end
      end
    end
  end
end
