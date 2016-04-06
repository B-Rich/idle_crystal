require "./utils/*"
require "./resource/manager"
require "./production/manager"
require "./research/manager"

class IdleCrystal::Civilization
  def initialize
    @name = "Test"
    @tick = 0_i64

    @resources_manager = IdleCrystal::Resource::Manager.new
    @production_manager = IdleCrystal::Production::Manager.new(@resources_manager)
    @research_manager = IdleCrystal::Research::Manager.new(@resources_manager, @production_manager)
  end

  def next_tick
    @tick += 1
    @production_manager.next_tick
  end

  def load
    @resources_manager.load
    @production_manager.load
  end

  def save
    @resources_manager.save
    @production_manager.save
  end

  getter :resources_manager, :production_manager, :research_manager, :name, :tick

end
