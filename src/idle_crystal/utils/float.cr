struct Float64
  def to_s_human
    to_s.gsub(/(e\+)/, " 10^")
  end
end
