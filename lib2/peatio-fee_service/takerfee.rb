require "peatio-fee_service/takerfee/version"

module Peatio
  module FeeService
    module Takerfee
      require_relative 'services/fee_service'
      require_relative 'takerfee/version'
      require_relative 'takerfee/order'
      require_relative 'takerfee/withdraw'

      Peatio::FeeService.order_middlewares    << Order.new
      Peatio::FeeService.withdraw_middlewares << Withdraw.new
    end
  end
end
