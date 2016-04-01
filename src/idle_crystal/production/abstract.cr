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

  def per_tick
    v = 0.0
    @buildings.each do |b|
      v += v[1] * b[2].to_f
    end
    return v
  end

  def file_path
    File.join(["data", "#{name}.yml"])
  end

end
