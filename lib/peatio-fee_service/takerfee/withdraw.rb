module Peatio
  module Takerfee
    class Withdraw < Peatio::FeeService::Withdraw

      def on_submit(withdraw)
        Fee.new\
          parent: withdraw,
          source_account: withdraw.account,
          target_account: Fee::PLATFORM_ACCOUNT_ID,
          amount: withdraw.sum * 0.0015 # TODO: use withdraw.amount
      end

      def on_complete(withdraw)
        # Don't add any extra fees on withdraw complete.
      end

      def on_cancel(withdraw)
        Fee.new\
          parent: withdraw,
          source_account: Fee::PLATFORM_ACCOUNT_ID,
          target_account: withdraw.account,
          amount: withdraw.sum * 0.0015 # TODO: use withdraw.amount
      end
    end
  end
end
