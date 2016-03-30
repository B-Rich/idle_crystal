require "./production/abstract"
require "./production/food"

class IdleCrystal::ProductionManager
  def initialize(rm)
    @resource_manager = rm
    @food = IdleCrystal::Production::Food.new


  end
end
