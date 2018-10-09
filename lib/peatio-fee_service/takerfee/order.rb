module Peatio
  module FeeService
    module Takerfee
      class Order < Order
        def lock!(order)
          Fee.create!\
            parent: order,
            source_account: order.hold_account,
            target_account: Fee::PLATFORM_ACCOUNT_ID,
            amount: order.origin_volume * 0.001
        end

        def charge!(order, trade)
          # Select market_maker older order.
          market_maker = [trade.ask, trade.bid].min_by(&:created_at)
          # Pay fees back for market_maker.
          if order.created_at == market_maker
            Fee.create!\
              parent: order,
              source_account: nil,
              target_account: Fee::PLATFORM_ACCOUNT_ID,
              amount: order.origin_volume * 0.001
          end
        end
      end
    end
  end
end
