require "./resource_pack"

class IdleCrystal::ResourcesManager
  def initialize
    @resources_pack = IdleCrystal::ResourcePack.new
    @resources_pack.volume("food", 10.0)
    @resources_pack.volume("wood", 10.0)

    @production_resources_pack = IdleCrystal::ResourcePack.new
  end

  def tick_start
    @production_resources_pack.clear
  end

  def add_from_production(pack)
    @resources_pack.add(pack)
    @production_resources_pack.add(pack)
  end

  getter :resources_pack, :production_resources_pack

end
