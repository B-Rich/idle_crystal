require "../resource_pack"

class IdleCrystal::Production::Building
  def initialize(h : YAML::Any)
    @name = h["name"]
    @cost = h["cost"].as_h
    @produce = h["produce"].as_h
    @coeff = h["coeff"].to_s.to_f
    @amount = 0 as Int32
    @build_key = h["build_key"].to_s[0]
  end

  def cost_for_unit(unit)
    rp = IdleCrystal::ResourcePack.new
    @cost.keys.each do |k|
      volume = @cost[k].to_s.to_f * (@coeff ** unit)
      rp.volume(k.to_s, volume)
    end

    return rp
  end

  def cost_for_next
    cost_for_unit(@amount + 1)
  end

  def produce
    rp = IdleCrystal::ResourcePack.new
    @produce.keys.each do |k|
      volume = @produce[k].to_s.to_f * @amount
      rp.volume(k.to_s, volume)
    end

    return rp
  end

  def build
    @amount += 1
  end

  def to_s_list
    "#{build_key}: #{name} - #{amount} (cost #{cost_for_next.to_short_s}, produce #{produce.to_short_s})"
  end

  getter :name, :amount, :build_key
end
