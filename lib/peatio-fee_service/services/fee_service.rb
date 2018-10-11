# THIS WILL BE MOVED TO PEATIO-CORE.
# binding.pry
# require 'peatio'

module Peatio
  class FeeService

    OPERATIONS = %i[order withdraw].freeze
    ACTIONS    = %i[on_submit on_complete on_cancel].freeze

    class << self
      ACTIONS.each do |method|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(operation_type, *args)
            run_middlewares(:#{method}, operation_type, *args)
          end
        RUBY
      end

      def run_middlewares(method, operation_type, *args)
        operation = operation(operation_type)

        middlewares = method("#{operation}_middlewares").call
        middlewares
          .each_with_object([]) do |middleware, fees|
            fees << middleware.public_send(method, *args)
          end
          .compact
          .yield_self { |fees| FeeService.new(fees) }
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

    attr_accessor :fees

    def initialize(fees)
      @fees = Array(fees)
    end

    def submit!
      ActiveRecord::Base.transaction do
        fees.each do |fee|
          fee.source_account&.lock_funds!(fee.amount)
        end
      end
    end

    def complete!
      ActiveRecord::Base.transaction do
        fees.each do |fee|
          fee.source_account&.unlock_and_sub_funds!(fee.amount)
          fee.target_account&.plus_funds!(fee.amount)
        end
      end
    end
  end
end
