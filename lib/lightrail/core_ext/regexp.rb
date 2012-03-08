class Regexp
  class << self
    def email
      /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
    end
  end
end