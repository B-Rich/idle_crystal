require "./abstract_content"
require "./content_building"
require "./content_research"

class IdleCrystal::Interface::ContentManager
  def initialize(@civilization, @max_width, @max_height)
    @content = NCurses::Window.new(@max_height - IdleCrystal::Interface::Main::RESOURCES_HEIGHT, @max_width, 2, 0)
    @tab_cursor = 0
    @page_cursor = 0

    @production_manager = @civilization.production_manager

    @content_tabs = Array(IdleCrystal::Interface::AbstractContent).new

    @content_tabs << IdleCrystal::Interface::ContentResearch.new(@content, @civilization)
    @production_manager.resources.each_with_index do |key, value, index|
      @content_tabs << IdleCrystal::Interface::ContentBuilding.new(@content, value, @production_manager)
    end
    
  end

  def current_tab
    @content_tabs[@tab_cursor]
  end

  def current_tab_cursor
    @tab_cursor
  end

  def max_tab_cursor
    @content_tabs.size - 1
  end

  def current_page_cursor
    @page_cursor
  end

  def max_page_cursor
    current_tab.max_page_cursor
  end

  def prev_tab
    if @tab_cursor > 0
      @tab_cursor -= 1
      @page_cursor = 0
    end
  end

  def next_tab
    if @tab_cursor < max_tab_cursor
      @tab_cursor += 1
      @page_cursor = 0
    end
  end

  def prev_page
    if @page_cursor > 0
      @page_cursor -= 1
    end
  end

  def next_page
    if @page_cursor < max_page_cursor
      @page_cursor += 1
    end
  end

  def render
    current_tab.render(@page_cursor)
  end
end
