module Claimer
  class Record

    attr_accessor :doctor_number, :clinic_number, :clinic_address,
      :clinic_city_and_prov, :clinic_postal_code, :hsn, :dob, :sex,
      :first_name, :last_name, :icd9, :date_of_service, :number_of_units,
      :fee, :fee_code, :claim_number

    def initialize(values = {})
      self.doctor_number        = values[:doctor_number]
      self.clinic_number        = values[:clinic_number]
      self.clinic_address       = values[:clinic_address]
      self.clinic_city_and_prov = values[:clinic_city_and_prov]
      self.clinic_postal_code   = values[:clinic_postal_code]
      self.hsn                  = values[:hsn]
      self.dob                  = values[:dob]
      self.sex                  = values[:sex]
      self.first_name           = values[:first_name]
      self.last_name            = values[:last_name]
      self.icd9                 = values[:icd9]
      self.date_of_service      = values[:date_of_service]
      self.number_of_units      = values[:number_of_units]
      self.fee                  = values[:fee]
      self.fee_code             = values[:fee_code]
      self.comments             = values[:comments]
      self.claim_number         = values[:claim_number] || 0
    end

  end
end