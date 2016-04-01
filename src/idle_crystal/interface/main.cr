require "ncurses"
require "./ui_resources"
require "./ui_buildings"

class IdleCrystal::Interface::Main
  def initialize(civ)
    @civilization = civ
    @resources_manager = @civilization.resources_manager as IdleCrystal::ResourcesManager
    @production_manager = @civilization.production_manager as IdleCrystal::ProductionManager

    NCurses.init
    NCurses.raw
    NCurses.no_echo

    @max_height, @max_width = NCurses.stdscr.max_dimensions

    @menu = NCurses::Window.new(1, @max_width, 0, 0)
    @content = NCurses::Window.new(@max_height - 2, @max_width, 2, 0)
    @resources = NCurses::Window.new(2, @max_width, @max_height - 2, 0)

    # resources
    @ui_resources = IdleCrystal::Interface::UiResources.new(@resources, @resources_manager)

    # production buildings
    @ui_buildings_modules = Hash(String, IdleCrystal::Interface::UiBuildings).new
    @production_manager.resources.each_with_index do |key, value, index|
      @ui_buildings_modules[key] = IdleCrystal::Interface::UiBuildings.new(@content, value)
    end

    @auto_refresh_every = 0.5
    @last_refresh = Time.now
    @enabled = true
    @cursor = 0

    render_menu
    render_content
  end

  # TODO move to external class
  def resources_active
    @ui_buildings_modules.values.select{|m| m.production.active }
  end

  def current_production
    resources_active[@cursor]
  end

  def max_cursor
    resources_active.size
  end


  def auto_refresh
    if (Time.now - @last_refresh).to_f > @auto_refresh_every
      refresh
    end
  end

  def refresh
    render_menu
    render_content
    render_resources

    @last_refresh = Time.now
  end

  def render_menu
    @menu.clear
    @menu.print("IdleCrystal - #{@cursor}")
    @menu.refresh
  end

  def render_content
    # @content.clear
    # @content.print("Content")
    # LibNCurses.mvwprintw(@content, 4, 5, "Test")
    # @content.refresh

    current_production.render
  end

  def render_resources
    @ui_resources.render
  end

  def start_interface
    #future do
      refresh

      while @enabled
        wait_for_input
        auto_refresh
        sleep 0.03
      end
    #end
  end

  def wait_for_input
    @menu.timeout = 0.2
    char = @menu.get_char
    case char
    when 68
      move_cursor(-1)
      refresh
    when 67
      move_cursor(1)
      refresh
    when 'q'
      @enabled = false
      # when 27 then # esc
      #  @enabled = false
    else
      # if return true, then must update
      #result = current_module.send_key(char)
      #refresh if result
    end
  end

  def move_cursor(offset)
    return unless 0 <= @cursor + offset < max_cursor
    @cursor += offset
  end

  def stop
    NCurses.end_win
  end
end
