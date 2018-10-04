module Peatio
  module Takerfee
    class Withdraw < Peatio::FeesService::Withdraw
      def lock!(withdraw)

      end

      def charge!(withdraw)

      end
    end

    class Order < Peatio::FeesService::Order
      def lock!(order)
        Fee.new
      end

      def charge!(order, trade)
        Fee.new
      end
    end

    Peatio::FeesService.order_middlewares    << Order.new
    Peatio::FeesService.withdraw_middlewares << Withdraw.new
  end
end
