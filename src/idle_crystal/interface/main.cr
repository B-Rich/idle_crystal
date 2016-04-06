require "ncurses"

require "./helper"
require "./menu"
require "./resources"
require "./content_manager"


class IdleCrystal::Interface::Main
  COLOR_DEFAULT = 0
  COLOR_GREEN = 1
  COLOR_RED = 2
  COLOR_BLUE = 3

  RESOURCES_HEIGHT = 3

  def initialize(civ)
    @civilization = civ
    @resources_manager = @civilization.resources_manager as IdleCrystal::Resource::Manager
    @production_manager = @civilization.production_manager as IdleCrystal::Production::Manager

    NCurses.init
    NCurses.raw
    NCurses.no_echo
    NCurses.start_color

    LibNCurses.init_pair(COLOR_GREEN, 2, 0)
    LibNCurses.init_pair(COLOR_BLUE, 3, 0)
    LibNCurses.init_pair(COLOR_RED, 1, 0)

    @window = NCurses.stdscr
    @max_height, @max_width = @window.max_dimensions
    @content_manager = IdleCrystal::Interface::ContentManager.new(@civilization, @max_width, @max_height)
    @menu = IdleCrystal::Interface::Menu.new(@civilization, @content_manager, @max_width)
    @resources = IdleCrystal::Interface::Resources.new(@resources_manager)


    @auto_refresh_every = 0.5
    @last_refresh = Time.now

    @tick_every = 1.0
    @last_tick = Time.now

    @enabled = true
    @cursor = 0

    refresh
  end

  def next_tick!
    @last_tick = Time.now
    @civilization.next_tick
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
    @menu.render(@content_manager)
    render_content
    render_resources

    @last_refresh = Time.now
  end


  def render_content
    @content_manager.render
  end

  def render_resources
    @resources.render
  end

  def start_interface
    refresh

    while @enabled
      wait_for_input
      auto_refresh
      next_tick
      sleep 0.03
    end

    stop
  end

  def wait_for_input
    @window.timeout = 0.2
    char = @window.get_char
    case char
    when 68
      @content_manager.prev_tab
      refresh
    when 67
      @content_manager.next_tab
      refresh
    when 65
      @content_manager.prev_page
      refresh
    when 66
      @content_manager.next_page
      refresh

    when 'q'
      @enabled = false

    else
      # if return true, then must update
      result = @content_manager.current_tab.send_key(char)
      refresh if result
    end
  end

  def stop
    @civilization.save

    NCurses.end_win
  end
end
