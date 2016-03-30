require "./abstract"

class IdleCrystal::Production::Wood < IdleCrystal::Production::Abstract
  def file_path
    File.join(["data", "wood.yml"])
  end
end
