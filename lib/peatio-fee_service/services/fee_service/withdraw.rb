module Peatio
  class FeeService::Withdraw
    # This method will be called to calculate fees when we submit Withdraw
    # inside WithdrawService
    def on_submit(withdraw)
      method_not_implemented
    end

    #
    def on_complete(withdraw)
      method_not_implemented
    end

    def on_cancel(withdraw)
      method_not_implemented
    end
  end
end
