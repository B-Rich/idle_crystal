require "ncurses"
require "../production/resource"

class IdleCrystal::Interface::UiBuildingsPerResource
  def initialize(w : NCurses::Window, p : IdleCrystal::Production::Resource, pm : IdleCrystal::Production::Manager)
    @window = w
    @production = p
    @production_manager = pm
    @resource_manager = pm.resource_manager
  end

  getter :production

  def render
    @window.clear

    texts = @production.buildings.map{|b| b.to_s_list}
    x = 0
    y = 0
    length = texts.map{|t| t.size}.max
    max_length = @window.max_dimensions[1]

    @production.buildings.each_with_index do |b, index|
      if @resource_manager.resources_pack >= b.cost_for_next
        LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_GREEN, nil)
      else
        LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_RED, nil)
      end
      LibNCurses.mvwprintw(@window, y, x, b.to_s_list)
      LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_DEFAULT, nil)

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
    if building.is_a?(IdleCrystal::Production::Building)
      return @production_manager.build(building)
    else
      return false
    end
  end

end
