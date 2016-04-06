class IdleCrystal::Research::Tech
  def initialize(h : YAML::Any)
    @name = h["name"]
    @cost = h["cost"].as_h
    @research_key = h["research_key"].to_s[0]
    @coeff = 1.1
    @coeff = h["coeff"].to_s.to_f if h["coeff"]?

    @level = 0 as Int32
  end

  getter :level, :name, :research_key

  def set_level(l : Int32)
    @level = l
  end

  def cost_for_unit(unit)
    rp = IdleCrystal::Resource::Pack.new
    @cost.keys.each do |k|
      volume = @cost[k].to_s.to_f * (@coeff ** unit)
      rp.set(k.to_s, volume)
    end

    return rp
  end

  def cost_for_next
    cost_for_unit(@level + 1)
  end

  def to_s_list
    #  (cost #{cost_for_next.to_short_s}, produce #{produce.to_short_s})
    "#{research_key}: #{name} - level: #{level}"
  end
end
