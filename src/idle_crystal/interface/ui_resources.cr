require "ncurses"

class IdleCrystal::Interface::UiResources
  def initialize(w : NCurses::Window, rm : IdleCrystal::ResourcesManager)
    @window = w
    @resource_manager = rm
  end

  def render
    @window.clear

    texts = @resource_manager.resources.keys.map{|key| "#{key}: #{@resource_manager.resources[key]}"}
    x = 0
    y = 0
    length = texts.map{|t| t.size}.max
    max_length = @window.max_dimensions[1]

    @resource_manager.resources.each_with_index do |key, value, index|
      LibNCurses.mvwprintw(@window, y, x, "#{key}: #{value}")
      x += (length + 4)
      if x >= max_length
        y += 1
        x = 0
      end
    end

    @window.refresh
  end
end
