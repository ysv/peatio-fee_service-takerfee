binding.pry
require 'peatio-fee_service/services/fee_service'
require 'peatio-fee_service/takerfee/version'
require 'peatio-fee_service/takerfee/order'
require 'peatio-fee_service/takerfee/withdraw'

module Peatio
  module FeeService
    module Takerfee
      Peatio::FeeService.order_middlewares    << Order.new
      Peatio::FeeService.withdraw_middlewares << Withdraw.new
      # binding.pry
    end
  end
end
