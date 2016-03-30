class IdleCrystal::ResourcePack
  def initialize
    @resources = Hash(String, Float64).new
  end

  def volume(name : String, value : Float64)
    @resources[name] = value
  end

  def volume(name : String)
    @resources[name]
  end
end
