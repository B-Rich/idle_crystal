require "./pack"

class IdleCrystal::Resource::Manager
  SAVE_FILE_PATH = File.join(["save", "resource.yml"])

  def initialize
    @resources_pack = IdleCrystal::Resource::Pack.new
    default_resources

    @production_resources_pack = IdleCrystal::Resource::Pack.new
  end

  getter :resources_pack, :production_resources_pack

  def default_resources
    @resources_pack.set("work_force", 3.0)
    @resources_pack.set("food", 5.0)
    @resources_pack.set("wood", 3.0)
  end

  def tick_start
    @production_resources_pack.clear
  end

  def add_from_production(pack)
    @resources_pack.add(pack)
    @production_resources_pack.add(pack)
  end

  def save
    h = Hash(String, Float64).new
    @resources_pack.names.each do |r|
      h[r] = @resources_pack.get(r)
    end

    File.open(SAVE_FILE_PATH, "w") { |f| YAML.dump(h, f) }
  end

  def load
    return unless File.exists?(SAVE_FILE_PATH)
    h = YAML.parse(File.read(SAVE_FILE_PATH)).as_h

    h.keys.each do |r|
      @resources_pack.set(r.to_s, h[r].to_s.to_f)
    end
  end

end
