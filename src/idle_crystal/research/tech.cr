class IdleCrystal::Research::Tech
  def initialize(h : YAML::Any)
    @name = h["name"]
    @cost = h["cost"].as_h
    @research_key = h["research_key"].to_s[0]
    @coeff = 1.1
    @coeff = h["coeff"].to_s.to_f if h["coeff"]?
    @milestone = false
    if h["milestone"]?
      @milestone = (h["milestone"].to_s == "true")
    end

    @level = 0 as Int32
  end

  getter :level, :name, :research_key

  def set_level(l : Int32)
    @level = l
  end

  def research
    @level += 1
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
    s = "#{research_key}: #{name}"
    if @milestone == false
      s += " - level: #{level}"
    end
    return s
  end

  def enabled?
    if @level > 0 && @milestone
      return false
    end
    return true
  end
end
