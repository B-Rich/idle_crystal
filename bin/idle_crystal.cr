require "json"
require "../src/idle_crystal"

civ = IdleCrystal::Civilization.new
# puts civ.inspect

a = IdleCrystal::Interface::Main.new(civ)
a.start_interface
a.stop
