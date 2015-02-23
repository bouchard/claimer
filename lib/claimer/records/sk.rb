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
      n = n.to_s.gsub(/[^\d]/,'').rjust(9, '0')
      11 - 1.upto(8).map{ |d| n[d].to_i * (d + 1) }.inject(0, &:+) % 11 == n[0].to_i
    end

  end
end