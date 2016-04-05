require "ncurses"

class IdleCrystal::Interface::Menu
  def initialize(@civilization, @content_manager, max_width)
    @menu = NCurses::Window.new(1, max_width, 0, 0)
  end

  def render(ui_buildings)
    @menu.clear

    max_length = @menu.max_dimensions[1]

    text = "IdleCrystal: #{@civilization.name}, #{@content_manager.current_tab_cursor + 1}/#{@content_manager.max_tab_cursor + 1}"
    LibNCurses.mvwprintw(@menu, 0, 0, text)

    text = "turn #{@civilization.tick}"
    LibNCurses.mvwprintw(@menu, 0, max_length - text.size - 1, text)

    text = @content_manager.current_tab.name
    LibNCurses.mvwprintw(@menu, 0, (max_length - text.size) / 2, text)

    @menu.refresh
  end

end
