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
      def on_submit(operation_type, *args)
        operation = operation(operation_type)

        middlewares = method("#{operation}_middlewares").call
        a = middlewares.each_with_object([]) do |middleware, fees|
          fees << middleware.on_submit(*args)
        end.compact
        binding.pry
        a
      rescue StandardError => e
        raise Error, e.message
      end

      def on_complete(operation_type, *args)
        operation = operation(operation_type)

        middlewares = method("#{operation}_middlewares").call
        a = middlewares.each_with_object([]) do |middleware, fees|
          fees << middleware.on_complete(*args)
        end.compact
        binding.pry
        a
      rescue StandardError => e
        raise Error, e.message
      end

      def on_cancel(operation_type, *args)
        operation = operation(operation_type)

        middlewares = method("#{operation}_middlewares").call
        middlewares.each_with_object([]) do |middleware, fees|
          fees << middleware.on_cancel(*args)
        end.compact

      rescue StandardError => e
        raise Error, e.message
      end

      def operation(operation)
        operation.tap do |op|
          raise Error, 'Unsupported operation for FeeService.' unless op.to_s.in? %w[order withdraw]
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
