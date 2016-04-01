require "ncurses"
require "../production/abstract"

class IdleCrystal::Interface::UiBuildingsPerResource
  def initialize(w : NCurses::Window, p : IdleCrystal::Production::Abstract, pm : IdleCrystal::ProductionManager)
    @window = w
    @production = p
    @production_manager = pm
  end

  getter :production

  def render
    @window.clear

    texts = @production.buildings.map{|b| "#{b.build_key}: #{b.name} - #{b.amount}"}
    x = 0
    y = 0
    length = texts.map{|t| t.size}.max
    max_length = @window.max_dimensions[1]

    texts.each_with_index do |text, index|
      LibNCurses.mvwprintw(@window, y, x, text)
      y += 1
    end

    @window.refresh
  end

  def name
    @production.name
  end

  def find_building_for_build_key(char)
    a = @production.buildings.select{|b| b.build_key.ord == char}
    if a.size > 0
      a.first
    else
      nil
    end
  end

  def send_key(char)
    building = find_building_for_build_key(char)
    if building.is_a?(IdleCrystal::Production::ProductionBuilding)
      return @production_manager.build(building)
    else
      return false
    end
  end

end
