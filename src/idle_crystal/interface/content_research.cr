require "./abstract_content"
require "../civilization"
require "../research/manager"

class IdleCrystal::Interface::ContentResearch < IdleCrystal::Interface::AbstractContent
  LINES_PER_TECH = 5

  def initialize(w : NCurses::Window, c : IdleCrystal::Civilization)
    @window = w
    @max_height, @max_width = @window.max_dimensions

    @civilization = c
    @production_manager = c.production_manager
    @resources_manager = c.resources_manager
    @research_manager = c.research_manager

    @techs = @research_manager.techs
  end

  def techs_per_page
    (@max_height.to_f / LINES_PER_TECH.to_f).floor.to_i
  end

  def max_page_cursor
    i = ( @techs.size.to_f / techs_per_page.to_f ).ceil.to_i - 1
    i = 0 if i < 0
    return i
  end

  # def find_tech_for_build_key(char)
  #   a = @production.buildings.select{|b| b.build_key.ord == char}
  #   if a.size > 0
  #     a.first
  #   else
  #     nil
  #   end
  # end

  def send_key(char)
    return false

    # building = find_building_for_build_key(char)
    # if building.is_a?(IdleCrystal::Production::Building)
    #   return @production_manager.build(building)
    # else
    #   return false
    # end
  end

  def name
    "research"
  end

  def techs_for_page(page : Int32)
    @techs[(techs_per_page * page), (techs_per_page * (page+1))]
  end

  def render(page)
    @window.clear

    techs = techs_for_page(page)

    y = 0

    techs.each_with_index do |t, index|
      render_tech(t, y)
      y += LINES_PER_TECH
    end

    @window.refresh
  end

  def render_tech(tech, y)
    if @resources_manager.resources_pack >= tech.cost_for_next
      LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_GREEN, nil)
    else
      LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_RED, nil)
    end
    LibNCurses.mvwprintw(@window, y, 0, tech.to_s_list)
    LibNCurses.wcolor_set(@window, IdleCrystal::Interface::Main::COLOR_DEFAULT, nil)

    #render_building_table(building, y)
  end
  #
  # def render_building_table(building, y)
  #   cost_hash = building.cost_for_next.hash
  #   produce_hash = building.produce.hash
  #
  #   keys = (cost_hash.keys + produce_hash.keys).uniq.sort
  #   key_max_size = keys.map{|k| k.size}.max
  #   key_max_size = 12 if key_max_size < 12
  #
  #   LibNCurses.mvwprintw(@window, y + 1, 3, "cost")
  #   LibNCurses.mvwprintw(@window, y + 2, 3, "produce")
  #
  #   keys.each_with_index do |k, i|
  #     x = 3 + 12 + (key_max_size + 2) * i
  #
  #     if cost_hash.has_key?(k)
  #       LibNCurses.mvwprintw(@window, y + 1, x, "#{cost_hash[k].to_s_human}")
  #     end
  #
  #     if produce_hash.has_key?(k)
  #       LibNCurses.mvwprintw(@window, y + 2, x, "#{produce_hash[k].to_s_human}")
  #     end
  #   end
  #
  #   # LibNCurses.mvwprintw(@window, y + 1, 3, "cost: #{building.cost_for_next.to_short_s}")
  #   # LibNCurses.mvwprintw(@window, y + 2, 3, "produce: #{building.produce.to_short_s}")
  #
  # end

end
