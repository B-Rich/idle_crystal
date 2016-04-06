require "./abstract_content"

class IdleCrystal::Interface::ContentBuilding < IdleCrystal::Interface::AbstractContent
  LINES_PER_BUILDING = 5

  def initialize(w : NCurses::Window, p : IdleCrystal::Production::Resource, pm : IdleCrystal::Production::Manager, rm : IdleCrystal::Research::Manager)
    @window = w
    @max_height, @max_width = @window.max_dimensions

    @production = p
    @production_manager = pm
    @resources_manager = pm.resources_manager
    @research_manager = rm
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

  def available_buildings
    @production.buildings.select{|b| @research_manager.can_you_build?(b)}
  end

  def buildings_for_page(page : Int32)
    available_buildings.[(buildings_per_page * page), (buildings_per_page * (page+1))]
  end

  def render(page)
    @window.clear

    buildings = buildings_for_page(page)

    y = 0

    buildings.each_with_index do |b, index|
      render_building(b, y)
      y += LINES_PER_BUILDING
    end

    @window.refresh
  end

  def render_building(building, y)
    if @resources_manager.resources_pack >= building.cost_for_next
      LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_GREEN, nil)
    else
      LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_RED, nil)
    end
    LibNCurses.mvwprintw(@window, y, 0, building.to_s_list)
    LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_DEFAULT, nil)

    IdleCrystal::Interface::Helper.render_building_table(building, @window, 2, y + 1)
  end

  def render_building_table(building, y)
    cost_hash = building.cost_for_next.hash
    produce_hash = building.produce.hash

    keys = (cost_hash.keys + produce_hash.keys).uniq.sort
    key_max_size = keys.map{|k| k.size}.max
    key_max_size = 12 if key_max_size < 12

    LibNCurses.mvwprintw(@window, y + 1, 3, "cost")
    LibNCurses.mvwprintw(@window, y + 2, 3, "produce")

    keys.each_with_index do |k, i|
      x = 3 + 12 + (key_max_size + 2) * i

      if cost_hash.has_key?(k)
        LibNCurses.mvwprintw(@window, y + 1, x, "#{cost_hash[k].to_s_human}")
      end

      if produce_hash.has_key?(k)
        LibNCurses.mvwprintw(@window, y + 2, x, "#{produce_hash[k].to_s_human}")
      end
    end

    # LibNCurses.mvwprintw(@window, y + 1, 3, "cost: #{building.cost_for_next.to_short_s}")
    # LibNCurses.mvwprintw(@window, y + 2, 3, "produce: #{building.produce.to_short_s}")

  end

end
