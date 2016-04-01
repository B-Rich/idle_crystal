require "yaml"

class IdleCrystal::ResourcesManager
  def initialize
    @resources = {
      "food" => 1.0,
      "wood" => 1.0
    }
  end

  getter :resources

end
