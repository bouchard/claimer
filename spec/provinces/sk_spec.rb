require 'spec_helper'
require_relative 'test_submission'

describe Claimer::SKGateway do
  before(:all) do
    require 'csv'
    @gateway = Claimer::SKGateway.new
    CSV.foreach(File.expand_path('./sk_test.csv', File.dirname(__FILE__)), headers: true) do |csv|
      @gateway.add_record(
        hsn: csv['hsn'],
        sex: csv['sex'],
        dob: parse_dob(csv['dob']),
        last_name: csv['name'].split(',')[0].strip,
        first_name: csv['name'].split(',')[1].strip,
        claim_number: csv['claim_number'],
        claim_sequence_number: csv['claim_sequence_number'],
        icd9: csv['icd9'],
        date_of_service: parse_date(csv['start_date']),
        end_date_of_service: parse_date(csv['end_date']),
        number_of_units: csv['visits_or_units'],
        fee_code: csv['fee_code'],
        fee: (csv['fee'].to_f * 100).round,
        referring_doctor: csv['referring_doctor'],
        location: csv['location'],
        comments: csv['comment'],
        doctor_number: 9800,
        doctor_name: 'General Practice',
        clinic_number: 000
      )
    end
  end

  it 'validates test data against known good submission' do
    expect(@gateway.finalize!).to eq(KNOWN_GOOD_SUBMISSION)
  end

  def parse_date(d)
    return d unless d.is_a?(String)
    return nil if d.nil?
    Date.strptime(d.rjust(6, '0'), '%d%m%y')
  end

  def parse_dob(d)
    return d unless d.is_a?(String)
    return nil if d.nil?
    Date.strptime(d.rjust(4, '0'), '%m%y')
  end
end

describe Claimer::SKRecord do

  it 'validates good HSN using modulo 11 check' do
    expect { Claimer::SKRecord.new(hsn: 508173299) }.not_to raise_error
  end

  it 'rejects bad HSN using modulo 11 check' do
    expect { Claimer::SKRecord.new(hsn: 508173298) }.to raise_error("HSN is invalid (fails modulo 11 check).")
  end

end