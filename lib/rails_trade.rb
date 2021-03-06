require 'rails_com'
require 'rails_auth'
require 'rails_role'
require 'rails_data'
require 'rails_audit'

require 'rails_trade/engine'
require 'rails_trade/config'

module RailsTrade
  @buyer_classes = []
  @good_classes = []

  class << self
    attr_accessor :buyer_classes, :good_classes
  end

end
