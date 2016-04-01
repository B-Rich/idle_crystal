# Class for operation on various resources
class IdleCrystal::ResourcePack
  def initialize
    @resources = Hash(String, Float64).new
  end

  def volume(name : String, value : Float64)
    @resources[name] = value
  end

  def volume(name : String)
    @resources[name]
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

  def >(other : IdleCrystal::ResourcePack)
    other.hash.keys.each do |k|
      if self.volume(k) < other.volume(k)
        return false
      end
    end
    return true
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
end
