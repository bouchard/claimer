require 'spec_helper'

KNOWN_GOOD_SUBMISSION = %|109800000000000000000000GENERAL PRACTICE0000000000000000000000000000000000000000000000000000000000000000000000000008
509800100860621030081039FSAMPSON MARY             737    180600011003B00390018
509800100870880060000669MSAMPSON JOHN             078    180600011005B00192518
509800100880730700090874MGREEN DAVID              535    190600011003B00390018
509800100890721650140514FHOERDT OLGA              207    190600011009L00600018
509800100890721650140514FHOERDT OLGA              207    190600011817A00229018
509800100900700030091161MBEACH ANDY               300    210600011003B00390018
509800100910620340061260MKIPLING BRIAN            729    210600011005D00192518
509800100920731020080261FFISHER SUSAN             550    190600011009L00600018
509800100930620340061260MKIPLING BRIAN            214    210600011362L01000018
60980010093062034006THIS IS A COMMENT THAT APPLIES TO THE ABOVE LINE
509800100940722150110261FMYERS SUSAN              221    210600011005B00192518
509800100950610010151039FANDERS MARY              207    180600011011B00235018
509800100960621000090737MANDERS FRANCIS           490    190600011005B00192518
509800100970620040000667MANDERS JOHN              289    140600011009B00470018
509800100980620040000667MANDERS JOHN              289    140600011025B00207018
509800100990722610050737FPLUE PENNY               300    210600011005B00192518
509800101000600020001039FEDWARDS MARY             194    210600011005B00192518
509800101010721710571037FMACK MARY                786    210600011005B00192518
509800101020621050190423MCRANE REG                V25    210600011190R01630018
9098009999990001800001000001869|

describe Claimer::SK do
  before(:all) do
    require 'csv'
    @gateway = Claimer::SK.new
    CSV.foreach(File.expand_path('./sk_test.csv', File.dirname(__FILE__)), :headers => true) do |csv|
      @gateway.add_record(
        :hsn                     => csv['hsn'],
        :sex                     => csv['sex'],
        :dob                     => parse_dob(csv['dob']),
        :last_name               => csv['name'].split(',')[0].strip,
        :first_name              => csv['name'].split(',')[1].strip,
        :claim_number            => csv['claim_number'],
        :claim_sequence_number   => csv['claim_sequence_number'],
        :icd9                    => csv['icd9'],
        :date_of_service         => parse_date(csv['start_date']),
        :end_date_of_service     => parse_date(csv['end_date']),
        :number_of_units         => csv['visits_or_units'],
        :fee_code                => csv['fee_code'],
        :fee                     => (csv['fee'].to_f * 100).round,
        :referring_doctor        => csv['referring_doctor'],
        :location                => csv['location'],
        :comments                => csv['comment'],
        :doctor_number           => 9800,
        :doctor_name             => 'General Practice',
        :clinic_number           => 000
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