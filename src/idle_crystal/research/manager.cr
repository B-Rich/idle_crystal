require "./tech"
require "yaml"

# Store all types of resources and perform production
class IdleCrystal::Research::Manager
  RESEARCH_LIST_PATH = File.join(["data", "research.yml"])
  SAVE_FILE_PATH = File.join(["save", "research.yml"])

  def initialize(rm : IdleCrystal::Resource::Manager, pm : IdleCrystal::Production::Manager)
    @resource_manager = rm
    @production_manager = pm

    @techs = Array(IdleCrystal::Research::Tech).new
    YAML.parse(File.read(RESEARCH_LIST_PATH)).each do |r|
      @techs << IdleCrystal::Research::Tech.new(r)
    end
  end

  getter :techs

  def research(tech : IdleCrystal::Research::Tech)
    cost_for_next = tech.cost_for_next

    if @resource_manager.resources_pack > cost_for_next
      @resource_manager.resources_pack.remove(cost_for_next)
      tech.research

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

  def find_by_name(n : String)
    a = @techs.select{|t| t.name == n}

    if a.size > 0
      return a.first
    else
      nil
    end
  end

  def save
    h = Hash(String, Int32).new
    @techs.each do |tech|
      h[tech.name] = tech.level
    end

    File.open(SAVE_FILE_PATH, "w") { |f| YAML.dump(h, f) }
  end

  def load
    return unless File.exists?(SAVE_FILE_PATH)
    h = YAML.parse(File.read(SAVE_FILE_PATH)).as_h

    h.keys.each do |k|
      tech = find_by_name(k.to_s)
      if tech.nil?
        # nothing
      else
        tech.set_level(h[k].to_s.to_i)
      end
    end
  end
end
