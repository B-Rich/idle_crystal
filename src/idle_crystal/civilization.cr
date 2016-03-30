require "./resources_manager"
require "./production_manager"

class IdleCrystal::Civilization
  def initialize
    @resources = IdleCrystal::ResourcesManager.new
    @production_manager = IdleCrystal::ProductionManager.new(@resources_manager)
  end
end
