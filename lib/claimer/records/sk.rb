module Claimer
  class SKRecord < Record

    def initialize(values = {})
      super(values)
    end

    def hsn=(hsn)
      raise "HSN is invalid (fails modulo 11 check)." unless modulo11_check(hsn)
      @hsn = hsn
    end

    private

    def modulo11_check(n)
      raise "HSN must be an integer to do the modulo 11 check." unless n.is_a?(Integer)
      11 - 1.upto(8).map{ |d| (n.div(10 ** d) % 10) * (d + 1) }.inject(0, &:+) % 11 == n % 10
    end

  end
end