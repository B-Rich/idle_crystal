class IdleCrystal::Interface::Helper
  def self.render_resource_table(array, window, x, y)
    resources = Array(String).new
    resource_max_size = 6

    array.each do |hash|
      k = hash.keys.first
      hash[k].keys.each do |r|
        resources << r unless resources.includes?(r)
        resource_max_size = r.size if r.size > resource_max_size
      end
    end

    # add number size
    resource_max_size += 10

    array.each_with_index do |hash, i|
      k = hash.keys.first
      local_y = y + i

      LibNCurses.mvwprintw(window, y + i, x, "| #{k}")
      hash[k].keys.each_with_index do |r, j|
        local_x = x + ( (resource_max_size + 4) * ( j + 1) )
        if hash[k].has_key?(r)
          LibNCurses.mvwprintw(window, local_y, local_x, "| #{r}: #{hash[k][r].to_s_human}")
        else
          LibNCurses.mvwprintw(window, local_y, local_x, "|")
        end
      end

      local_x = x + ( (resource_max_size + 4) * ( hash[k].keys.size + 1) )
      LibNCurses.mvwprintw(window, local_y, local_x, "|")
    end
  end

  def self.render_building_table(building, window, x, y)
    hash = [
      {"cost": building.cost_for_next.hash},
      {"produce_unit": building.produce_per_units(1).hash}
    ]

    render_resource_table(hash, window, x, y)
  end

  def self.render_tech_table(tech, window, x, y)
    hash = [
      {"cost": tech.cost_for_next.hash}
    ]

    render_resource_table(hash, window, x, y)
  end
end
