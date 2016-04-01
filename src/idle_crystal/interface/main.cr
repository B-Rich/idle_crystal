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
    @ui_buildings = IdleCrystal::Interface::UiBuildings.new(@content, @production_manager)

    @auto_refresh_every = 0.5
    @last_refresh = Time.now

    @tick_every = 1.0
    @last_tick = Time.now

    @enabled = true
    @cursor = 0

    render_menu
    render_content
  end

  def next_tick!
    @last_tick = Time.now
    @civilization.next_tick
  end

  def max_cursor
    @ui_buildings.max_cursor
  end

  def auto_refresh
    if (Time.now - @last_refresh).to_f > @auto_refresh_every
      refresh
    end
  end

  def next_tick
    if (Time.now - @last_tick).to_f > @tick_every
      next_tick!
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

    max_length = @menu.max_dimensions[1]

    text = "IdleCrystal: #{@civilization.name}"
    LibNCurses.mvwprintw(@menu, 0, 0, text)

    text = "turn #{@civilization.tick}"
    LibNCurses.mvwprintw(@menu, 0, max_length - text.size - 1, text)

    text = @ui_buildings.current_production.name
    LibNCurses.mvwprintw(@menu, 0, (max_length - text.size) / 2, text)

    @menu.refresh
  end

  def render_content
    @ui_buildings.render
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
        next_tick
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
      result = @ui_buildings.send_key(char)
      refresh if result
    end
  end

  def move_cursor(offset)
    return unless 0 <= @cursor + offset < max_cursor
    @cursor += offset
    @ui_buildings.cursor = @cursor
  end

  def stop
    NCurses.end_win
  end
end
