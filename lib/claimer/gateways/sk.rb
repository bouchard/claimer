module Claimer
  class SK < Gateway

    attr_accessor :records

    def initialize(values = {})
      self.records = []
    end

    def add_record
    end

    private

    def header_record(record)
      [
        '10', # Record type number
        record.doctor_number.to_s.rjust(4, '0'),
        '000000', # Filler
        record.clinic_number.to_s.rjust(3, '0'),
        record.clinic_name.to_s[0..24].rjust(25, '0'),
        record.clinic_address.to_s[0..24].rjust(25, '0'),
        record.clinic_city_and_prov.to_s[0..24].rjust(25, '0'),
        record.clinic_postal_code.to_s[0..24].rjust(25, '0'),
        '8', # Submission type: By Internet.
        '' # Practitioner billing.
      ].join('')
    end

    def record_format(record, claim_number)
      [
        '50', # Record type number
        record.doctor_number.to_s.rjust(4, '0'),
        claim_number.to_s[0..4],
        '0', # Placeholder for claim sequence number.
        record.hsn.to_s[0..8],
        record.dob.strftime('%m%y'),
        "#{record.last_name} #{record.first_name}"[0..24].ljust(25),
        record.icd9[0..2],
        ''.rjust(4), # Referring doctor number.
        record.date_of_service.strftime('%d%m%y'),
        record.number_of_units.to_s.rjust(2, '0'),
        '1', # Location of service
        record.fee_code.to_s.rjust(4, '0'),
        record.fee.to_s.gsub('.','').gsub('$','').rjust(6, '0'),
        '1', # Physician code.
        '8', # Submission by internet.
        ' ' * 19 # Filler.
      ].join('')
    end

    def comment_format(record, claim_number)
      return nil if record.comments.nil? || record.comments.length == 0
      [
        '60', # Record type number
        record.doctor_number.to_s.rjust(4, '0'),
        claim_number.to_s[0..4],
        '0', # Placeholder for claim sequence number.
        record.hsn.to_s[0..8],
        record.comments.to_s[0..76] # Comments.
      ].join('')
    end

    def collate
    end

    def publish
      self.records.each_with_index.map do |r, i|
        formatted_result = record_format(r, i)
        formatted_comment = comment_format(r, i)
        [ formatted_result, formatted_comment ].compact.join("\n")
      end.join("\n")
    end

  end
end