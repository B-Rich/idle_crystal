require "yaml"
require "./building"

# Store all building related to one type of source
class IdleCrystal::Production::Resource
  def initialize(n : String)
    @name = n
    @active = true

    @buildings = Array(IdleCrystal::Production::Building).new
    load_definitions_from_yaml
  end

  getter :buildings, :active, :name

  def load_definitions_from_yaml
    array = YAML.parse(File.read(file_path))
    array.each do |h|
      @buildings << IdleCrystal::Production::Building.new(h)
    end
  end

  def produce : IdleCrystal::Resource::Pack
    rp = IdleCrystal::Resource::Pack.new

    @buildings.each do |b|
      rp.add(b.produce)
    end

    return rp
  end

  def file_path
    File.join(["data", "production", "#{name}.yml"])
  end

end
