module Peatio
  module FeeService
    module Takerfee
      class Withdraw < Withdraw
        def on_submit(withdraw)
          Fee.new\
            parent: withdraw,
            source_account: withdraw.account,
            target_account: Fee::PLATFORM_ACCOUNT_ID,
            amount: withdraw.sum * 0.0015 # TODO: move to amount
        end

        def on_complete(withdraw)
          # Don't add any fees.
        end

        def on_cancel(withdraw)
          # TODO: return fees to withdraw account.
        end
      end
    end
  end
end
