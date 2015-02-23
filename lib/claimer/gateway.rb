module Claimer
  class Gateway
    def initialize
      raise "You must subclass for a province-specific gateway."
    end
  end
end