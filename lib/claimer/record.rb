module Claimer
  class Record

    attr_accessor :doctor_number, :referring_doctor_number, :doctor_name, :clinic_number,
      :clinic_address, :clinic_city_and_prov, :clinic_postal_code, :hsn, :dob,
      :sex, :first_name, :last_name, :icd9, :date_of_service, :end_date_of_service,
      :number_of_units, :fee, :fee_code, :comments, :claim_number,
      :claim_sequence_number, :in_hospital

    def initialize(values = {})
      raise "You need to instantiate province-specific records." if self.class == Record
      self.doctor_number           = values[:doctor_number]
      self.referring_doctor_number = values[:referring_doctor_number] || ''
      self.doctor_name             = values[:doctor_name]
      self.clinic_number           = values[:clinic_number]
      self.clinic_address          = values[:clinic_address]
      self.clinic_city_and_prov    = values[:clinic_city_and_prov]
      self.clinic_postal_code      = values[:clinic_postal_code]
      self.hsn                     = values[:hsn]
      self.dob                     = values[:dob]
      self.sex                     = values[:sex]
      self.first_name              = values[:first_name]
      self.last_name               = values[:last_name]
      self.icd9                    = values[:icd9]
      self.date_of_service         = values[:date_of_service]
      self.end_date_of_service     = values[:end_date_of_service]
      self.number_of_units         = values[:number_of_units]
      self.fee                     = values[:fee]
      self.fee_code                = values[:fee_code]
      self.comments                = values[:comments]
      self.claim_number            = values[:claim_number] || 0
      self.claim_sequence_number   = values[:claim_sequence_number] || 0
      self.in_hospital             = values[:in_hospital] || false
    end

  end
end