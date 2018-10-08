# THIS WILL BE MOVED TO PEATIO-CORE.
# binding.pry
require 'peatio'

module Peatio
  module FeeService

    # Error repesent all errors that can be returned from FeesService module.
    class Error < Peatio::Error
      def initialize(ex = nil)
        # TODO: Change code.
        super code: 1000,
              text: "FeesService failed".tap { |t| t << ": #{ex}" if ex.present? }
      end
    end

    class << self
      def lock!(*args)
        operation = operation_name(args.first)

        middlewares = method("#{operation}_middlewares").call
        middlewares.each do |middleware|
          middleware.lock!(*args)
        end
      rescue StandardError => e
        raise Error, e.message
      end

      def charge!(*args)
        operation = operation_name(args.first)

        middlewares = method("#{operation}_middlewares").call
        middlewares.each do |middleware|
          middleware.charge!(*args)
        end
      rescue StandardError => e
        raise Error, e.message
      end

      def operation_name(operation)
        case operation.class
        when Order
          :order
        when Withdraw
          :withdraw
        else
          raise Error, 'Unsupported operation for FeeService.'
        end
      end

      def order_middlewares=(list)
        @order_middlewares = list
      end

      def order_middlewares
        @order_middlewares ||= []
      end

      def withdraw_middlewares=(list)
        @withdraw_middlewares = list
      end

      def withdraw_middlewares
        @withdraw_middlewares ||= []
      end
    end

    class Withdraw
      def lock!(withdraw)
        method_not_implemented
      end

      def charge!(withdraw)
        method_not_implemented
      end
    end

    class Order
      def lock!(order)
        method_not_implemented
      end

      def charge!(order, trade)
        method_not_implemented
      end
    end
  end
end
