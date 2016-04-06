require "../resource/pack"

# One type of building (belongs to resource) which produce and/or converts
# resources to other types
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
    rp = IdleCrystal::Resource::Pack.new
    @cost.keys.each do |k|
      volume = @cost[k].to_s.to_f * (@coeff ** unit)
      rp.set(k.to_s, volume)
    end

    return rp
  end

  def cost_for_next
    cost_for_unit(@amount + 1)
  end

  def produce
    rp = IdleCrystal::Resource::Pack.new
    @produce.keys.each do |k|
      volume = @produce[k].to_s.to_f * @amount
      rp.set(k.to_s, volume)
    end

    return rp
  end

  def build
    @amount += 1
  end

  def amount_from_load(a : Int32)
    @amount = a
  end

  def to_s_list
    #  (cost #{cost_for_next.to_short_s}, produce #{produce.to_short_s})
    "#{build_key}: #{name} - amount: #{amount}"
  end

  getter :name, :amount, :build_key
end
