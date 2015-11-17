require 'dry/validation/predicate'

module Dry
  module Validation
    module Predicates
      module Methods
        def predicate(name, &block)
          register(name, Predicate.new(name, &block))
        end
      end

      extend Dry::Container::Mixin
      extend Methods

      predicate(:value?) do |name, input|
        input.key?(name)
      end

      predicate(:empty?) do |input|
        case input
        when String, Array, Hash then input.empty?
        when nil then true
        else
          false
        end
      end

      register(:filled?, self[:empty?].negation)

      predicate(:present?) do |name, input|
        self[:value?].(name, input) && self[:filled?].(input[name])
      end

      predicate(:int?) do |input|
        input.is_a?(Fixnum)
      end

      predicate(:gt?) do |num, input|
        input > num
      end
    end
  end
end
