require "yaml"

class IdleCrystal::ResourcesManager
  def initialize
    @food = 0.0
    @wood = 0.0
  end

  YAML.mapping({
    food: Float64,
    wood: Float64
  })

end
