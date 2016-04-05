abstract class IdleCrystal::Interface::AbstractContent
  abstract def max_page_cursor
  abstract def render(page : Int32)
  abstract def name : String
  abstract def send_key(char) : Bool
end
