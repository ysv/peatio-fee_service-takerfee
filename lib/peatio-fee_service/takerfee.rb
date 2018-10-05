require 'peatio-fee_service/services/fee_service'

module Peatio
  module FeeService
    module Takerfee
      require 'peatio-fee_service/takerfee/order'
      require 'peatio-fee_service/takerfee/withdraw'
      require 'peatio-fee_service/takerfee/version'

      Peatio::FeeService.order_middlewares    << Order.new
      Peatio::FeeService.withdraw_middlewares << Withdraw.new
    end
  end
end
