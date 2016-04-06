require "./abstract_content"
require "./helper"
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

  def find_tech_for_build_key(char)
    a = @techs.select{|t| t.research_key.ord == char}
    if a.size > 0
      a.first
    else
      nil
    end
  end

  def send_key(char)
    tech = find_tech_for_build_key(char)
    if tech.is_a?(IdleCrystal::Research::Tech)
      return @research_manager.research(tech)
    else
      return false
    end
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

    IdleCrystal::Interface::Helper.render_tech_table(tech, @window, 2, y + 1)
  end

end
