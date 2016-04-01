require "ncurses"
require "./ui_buildings_per_resource"

class IdleCrystal::Interface::UiBuildings
  def initialize(w : NCurses::Window, pm : IdleCrystal::ProductionManager)
    @production_manager = pm
    @content = w
    @cursor = 0 as Int32

    @ui_buildings_modules = Hash(String, IdleCrystal::Interface::UiBuildingsPerResource).new
    @production_manager.resources.each_with_index do |key, value, index|
      @ui_buildings_modules[key] = IdleCrystal::Interface::UiBuildingsPerResource.new(@content, value)
    end

  end

  property :cursor

  # List of all resources available now
  def resources_active
    @ui_buildings_modules.values.select{|m| m.production.active }
  end

  def current_production
    resources_active[@cursor]
  end

  def max_cursor
    resources_active.size
  end

  def render
    current_production.render
  end

  def send_key(char)
    current_production.send_key(char)
  end

end
