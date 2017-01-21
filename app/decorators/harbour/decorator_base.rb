module Harbour
  class DecoratorBase < SimpleDelegator
    def initialize(klass)
      @model = klass
      super(klass)
    end

    def class
      model.class
    end

    def to_json
      as_json
    end

    private

    def model
      @model
    end
  end
end
