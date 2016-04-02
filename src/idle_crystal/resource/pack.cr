# Class for operation on various resources
class IdleCrystal::Resource::Pack
  def initialize
    @resources = Hash(String, Float64).new
  end

  def get(name : String)
    if @resources.has_key?(name)
      return @resources[name]
    else
      return 0.0
    end
  end

  def set(name : String, value : Float64)
    @resources[name] = value
  end

  def add(name : String, value : Float64)
    if @resources.has_key?(name)
      set(name, get(name) + value)
    else
      set(name, value)
    end
  end

  def remove(name : String, value : Float64)
    if @resources.has_key?(name)
      set(name, get(name) - value)
    else
      set(name, -1.0 * value)
    end
  end

  def names
    @resources.keys
  end

  def hash
    @resources
  end

  def to_short_s
    hash.keys.map{|k| "#{k}: #{hash[k].to_s_human}"}.join(", ")
  end

  def >=(other : IdleCrystal::Resource::Pack)
    return ( (self<=>other) >= 0)
  end

  def >(other : IdleCrystal::Resource::Pack)
    return ( (self<=>other) > 0)
  end

  def <=>(other : IdleCrystal::Resource::Pack)
    # TODO return 0 only if all volumes are equal
    other.hash.keys.each do |k|
      if self.get(k) < other.get(k)
        return -1
      end
    end
    return 1
  end

  def add(other : IdleCrystal::Resource::Pack)
    other.hash.keys.each do |k|
      add(k, other.hash[k])
    end
    self
  end

  def remove(other : IdleCrystal::Resource::Pack)
    other.hash.keys.each do |k|
      remove(k, other.hash[k])
    end
    self
  end

  def clear
    hash.keys.each do |k|
      hash.delete(k)
    end
  end
end
