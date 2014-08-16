module Claimer

  autoload :SKGateway, 'claimer/gateways/sk'
  autoload :SKRecord, 'claimer/records/sk'

end

require 'claimer/version'
require 'claimer/gateway'
require 'claimer/record'