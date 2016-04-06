require "ncurses"

class IdleCrystal::Interface::Resources
  def initialize(rm : IdleCrystal::Resource::Manager)
    @screen = NCurses.stdscr
    @max_height, @max_width = @screen.max_dimensions

    @resource_manager = rm
    @window = NCurses::Window.new(
      IdleCrystal::Interface::Main::RESOURCES_HEIGHT,
      @max_width,
      @max_height - IdleCrystal::Interface::Main::RESOURCES_HEIGHT,
      0
    )
  end

  def render
    @window.clear

    resources_pack = @resource_manager.resources_pack
    resources_hash = resources_pack.hash
    production_resources_pack = @resource_manager.production_resources_pack
    production_resources_hash = production_resources_pack.hash
    texts = resources_hash.keys.map{|key| "#{key}: #{resources_pack.get(key).to_s_human} (+#{production_resources_pack.get(key).to_s_human})"}
    x = 0
    y = 0
    length = texts.map{|t| t.size}.max
    max_length = @window.max_dimensions[1]

    texts.each do |text|
      LibNCurses.mvwprintw(@window, y, x, text)
      x += (length + 4)
      if x >= max_length
        y += 1
        x = 0
      end
    end

    @window.refresh
  end
end
