require "./resource_pack"

class IdleCrystal::ResourcesManager
  def initialize
    @resources_pack = IdleCrystal::ResourcePack.new
    @resources_pack.volume("food", 10.0)
    @resources_pack.volume("wood", 10.0)
  end

  getter :resources_pack

end
