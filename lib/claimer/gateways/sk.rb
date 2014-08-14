module Claimer
  class SK < Gateway

    attr_accessor :records, :first_claim_number

    def initialize(values = {})
      self.records = []
      self.first_claim_number = 10000
    end

    def add_record(*args)
      self.records << Claimer::Record.new(*args)
    end

    def finalize!
      collate_records
    end

    def push!
      finalize!
    end

    private

    def header_record(selected_records)
      [
        '10', # Record type number
        selected_records.first.doctor_number.to_s.rjust(4, '0'),
        '000000', # Filler
        selected_records.first.clinic_number.to_s.rjust(3, '0'),
        selected_records.first.doctor_name.to_s[0..24].rjust(25, '0').upcase,
        selected_records.first.clinic_address.to_s[0..24].rjust(25, '0').upcase,
        selected_records.first.clinic_city_and_prov.to_s[0..24].rjust(25, '0').upcase,
        selected_records.first.clinic_postal_code.to_s[0..24].rjust(25, '0').upcase,
        '8', # Submission type: By Internet.
        '' # Practitioner billing.
      ].join('')
    end

    def trailer_record(selected_records)
      [
        '90', # Record type number
        selected_records.first.doctor_number.to_s.rjust(4, '0'),
        '999999', # Filler
        selected_records.count.to_s.rjust(5, '0'),
        selected_records.reject{ |r| r.comments.nil? || r.comments.length == 0 }.count.to_s.rjust(5, '0'),
        selected_records.count.to_s.rjust(7, '0'),
        '69' # Filler
      ].join('')
    end

    def record_format(record)
      if record.in_hospital
        hospital_record_format(record)
      else
        visit_record_format(record)
      end
    end

    def hospital_record_format(record)
      [
        '57', # Record type number
        record.doctor_number.to_s.rjust(4, '0'),
        record.claim_number.to_s[0..4],
        '0', # Placeholder for claim sequence number.
        record.hsn.to_s[0..8],
        record.dob.strftime('%m%y'),
        record.sex.to_s.upcase,
        "#{record.last_name} #{record.first_name}"[0..24].ljust(25),
        record.icd9.to_s[0..2].rjust(3, '0'),
        record.referring_doctor_number.rjust(4),
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

    def visit_record_format(record)
      [
        '50', # Record type number
        record.doctor_number.to_s.rjust(4, '0'),
        record.claim_number.to_s[0..4],
        '0', # Placeholder for claim sequence number.
        record.hsn.to_s[0..8],
        record.dob.strftime('%m%y'),
        record.sex.to_s.upcase,
        "#{record.last_name} #{record.first_name}"[0..24].ljust(25),
        record.icd9.to_s[0..2].rjust(3, '0'),
        record.referring_doctor_number.rjust(4),
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

    def comment_format(record)
      return nil if record.comments.nil? || record.comments.length == 0
      [
        '60', # Record type number
        record.doctor_number.to_s.rjust(4, '0'),
        record.claim_number.to_s[0..4],
        '0', # Placeholder for claim sequence number.
        record.hsn.to_s[0..8],
        record.comments.to_s[0..76].upcase # Comments.
      ].join('')
    end

    # Claim numbers are assigned sequentially starting at first_claim_number.
    # Claim sequence numbers are all 0 - this part of the API (if you can call it an API)
    # hasn't been implemented yet.
    def assign_claim_numbers
      c = self.first_claim_number
      self.records.each_with_index do |r|
        r.claim_number ||= c + r - 1
        r.claim_sequence_number ||= 0
      end
    end

    # MSB requires records to be sent in clinic-doctor sets.
    def collate_records

      assign_claim_numbers

      doctor_numbers = self.records.map{ |r| r.doctor_number }.uniq
      clinic_numbers = self.records.map{ |r| r.clinic_number }.uniq

      clinic_numbers.map do |cn|
        doctor_numbers.map do |dn|
          selected_records = self.records.select{ |r| r.doctor_number == dn && r.clinic_number == cn }
          [
            header_record(selected_records),
            selected_records.map do |r|
              formatted_result = record_format(r)
              formatted_comment = comment_format(r)
              [ formatted_result, formatted_comment ].compact.join("\n")
            end.join("\n"),
            trailer_record(selected_records)
          ].join("\n")
        end
      end
    end

  end
end