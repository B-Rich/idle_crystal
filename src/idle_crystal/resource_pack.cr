# Class for operation on various resources
class IdleCrystal::ResourcePack
  def initialize
    @resources = Hash(String, Float64).new
  end

  def volume(name : String, value : Float64)
    @resources[name] = value
  end

  def volume(name : String)
    if @resources.has_key?(name)
      return @resources[name]
    else
      return 0.0
    end
  end

  def add(name : String, value : Float64)
    if @resources.has_key?(name)
      volume(name, volume(name) + value)
    else
      volume(name, value)
    end
  end

  def remove(name : String, value : Float64)
    if @resources.has_key?(name)
      volume(name, volume(name) - value)
    else
      volume(name, -1.0 * value)
    end
  end

  def hash
    @resources
  end

  def to_short_s
    hash.keys.map{|k| "#{k}: #{hash[k]}"}.join(", ")
  end

  def >=(other : IdleCrystal::ResourcePack)
    return ( (self<=>other) >= 0)
  end

  def >(other : IdleCrystal::ResourcePack)
    return ( (self<=>other) > 0)
  end


  def <=>(other : IdleCrystal::ResourcePack)
    other.hash.keys.each do |k|
      if self.volume(k) < other.volume(k)
        return -1
      end
    end
    return 1
  end

  def add(other : IdleCrystal::ResourcePack)
    other.hash.keys.each do |k|
      add(k, other.hash[k])
    end
    self
  end

  def remove(other : IdleCrystal::ResourcePack)
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
