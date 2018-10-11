module Peatio
  module Takerfee
    class Order < Peatio::FeeService::Order
      def on_submit(order)
        Fee.new\
          parent: order,
          source_account: order.hold_account,
          target_account: Fee::PLATFORM_ACCOUNT_ID,
          amount: order.origin_volume * 0.001
      end

      def on_complete(order, trade)
        # Select market_maker older order.
        market_maker = [trade.ask, trade.bid].min_by(&:created_at)
        # Return fees to market_maker.
        # NOTE: We return only matched amount of fees
        if order.created_at == market_maker
          Fee.new\
            parent: order,
            source_account: Fee::PLATFORM_ACCOUNT_ID,
            target_account: order.hold_account,
            amount: trade.volume * 0.001
        end
      end

      def on_cancel(order)
        Fee.new\
          parent: order,
          source_account: Fee::PLATFORM_ACCOUNT_ID,
          taret_account:  order.hold_account,
          amount:         order.volume * 0.001
      end
    end
  end
end
