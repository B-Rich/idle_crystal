require "./abstract"

class IdleCrystal::Production::Food < IdleCrystal::Production::Abstract
  def file_path
    File.join(["data", "food.yml"])
  end
end
