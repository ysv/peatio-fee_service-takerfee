module Peatio
  module FeeService
    module Takerfee
      class Withdraw < Withdraw
        def lock!(withdraw)
          Fee.new\
            parent: withdraw,
            source_account: withdraw.account,
            target_account: Fee::PLATFORM_ACCOUNT_ID,
            amount: withdraw.amount * 0.0015
        end

        def charge!(withdraw)
          # Don't add any fees.
        end
      end
    end
  end
end
