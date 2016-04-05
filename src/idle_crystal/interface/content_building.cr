require "./abstract_content"

class IdleCrystal::Interface::ContentBuilding < IdleCrystal::Interface::AbstractContent
  LINES_PER_BUILDING = 5

  def initialize(w : NCurses::Window, p : IdleCrystal::Production::Resource, pm : IdleCrystal::Production::Manager)
    @window = w
    @max_height, @max_width = @window.max_dimensions

    @production = p
    @production_manager = pm
    @resource_manager = pm.resource_manager
  end

  def buildings_per_page
    (@max_height.to_f / LINES_PER_BUILDING.to_f).floor.to_i
  end

  def max_page_cursor
    i = ( @production.buildings.size.to_f / buildings_per_page.to_f ).ceil.to_i - 1
    i = 0 if i < 0
    return i
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

  def name
    @production.name
  end

  def buildings_for_page(page : Int32)
    @production.buildings[(buildings_per_page * page), (buildings_per_page * (page+1))]
  end

  def render(page)
    @window.clear

    buildings = buildings_for_page(page)

    y = 0

    buildings.each_with_index do |b, index|
      if @resource_manager.resources_pack >= b.cost_for_next
        LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_GREEN, nil)
      else
        LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_RED, nil)
      end
      LibNCurses.mvwprintw(@window, y, 0, b.to_s_list)
      LibNCurses.mvwprintw(@window, y + 1, 3, "cost: #{b.cost_for_next.to_short_s}")
      LibNCurses.mvwprintw(@window, y + 2, 3, "produce: #{b.produce.to_short_s}")

      LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_DEFAULT, nil)

      y += LINES_PER_BUILDING
    end

    @window.refresh
  end
end
