require "json"
require "../src/idle_crystal"

civ = IdleCrystal::Civilization.new
civ.load

a = IdleCrystal::Interface::Main.new(civ)
a.start_interface
a.stop
