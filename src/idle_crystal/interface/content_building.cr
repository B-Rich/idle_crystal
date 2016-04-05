require "./abstract_content"

class IdleCrystal::Interface::ContentBuilding < IdleCrystal::Interface::AbstractContent
  def initialize(w : NCurses::Window, p : IdleCrystal::Production::Resource, pm : IdleCrystal::Production::Manager)
    @window = w
    @production = p
    @production_manager = pm
    @resource_manager = pm.resource_manager
  end

  def max_page_cursor
    0
  end

  def send_key(char) : Bool
    false
  end

  def render
  end

  def name
    @production.name
  end
end
