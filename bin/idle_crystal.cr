require "json"
require "../src/idle_crystal"

civ = IdleCrystal::Civilization.new

a = IdleCrystal::Interface::Main.new(civ)
a.start_interface
a.stop
