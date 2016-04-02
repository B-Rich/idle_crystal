require "./utils/*"
require "./resources_manager"
require "./production/manager"

class IdleCrystal::Civilization
  def initialize
    @name = "Test"
    @tick = 0_i64

    @resources_manager = IdleCrystal::ResourcesManager.new
    @production_manager = IdleCrystal::Production::Manager.new(@resources_manager)
  end

  def next_tick
    @tick += 1
    @production_manager.next_tick
  end

  def load
    @production_manager.load
  end

  def save
    @production_manager.save
  end

  getter :resources_manager, :production_manager, :name, :tick

end
