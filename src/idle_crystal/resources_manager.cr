require "./resource_pack"

class IdleCrystal::ResourcesManager
  def initialize
    @resources_pack = IdleCrystal::ResourcePack.new
    @resources_pack.volume("work_force", 3.0)
    @resources_pack.volume("food", 5.0)
    @resources_pack.volume("wood", 3.0)

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
