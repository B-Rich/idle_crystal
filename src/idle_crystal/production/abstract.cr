require "yaml"
require "./production_building"

abstract class IdleCrystal::Production::Abstract
  def initialize
    @buildings = Array(IdleCrystal::Production::ProductionBuilding).new
    load_definitions_from_yaml

    @active = true
  end

  getter :buildings, :active

  abstract def file_path

  def load_definitions_from_yaml
    array = YAML.parse(File.read(file_path))
    array.each do |h|
      @buildings << IdleCrystal::Production::ProductionBuilding.new(h)
    end
  end


  def produce : IdleCrystal::ResourcePack
    rp = IdleCrystal::ResourcePack.new

    @buildings.each do |b|
      rp.add(b.produce)
    end

    return rp
  end

  def file_path
    File.join(["data", "#{name}.yml"])
  end

end
