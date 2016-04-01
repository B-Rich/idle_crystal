require "./resources_manager"
require "./production_manager"

class IdleCrystal::Civilization
  def initialize
    @name = "Test"
    @tick = 0_i64

    @resources_manager = IdleCrystal::ResourcesManager.new
    @production_manager = IdleCrystal::ProductionManager.new(@resources_manager)
  end

  getter :resources_manager, :production_manager, :name, :tick

end
