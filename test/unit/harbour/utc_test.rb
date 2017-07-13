require 'test_helper'

module Harbour
  class Target
    include Harbour::Utc
  end
  class UtcTest < Minitest::Test
    def setup
      @target = Target.new
    end

    def test_convert_dates_to_utc_in_nested_structure
      structure = <<-EOS
{
  "foo": {
    "bar": [
      {
        "date": "2017-06-07T16:23:06.576+01:00"
      }
    ]
  }
}
EOS
    assert_equal "{\"foo\":{\"bar\":[{\"date\":\"2017-06-07T15:23:06Z\"}]}}", @target.convert_dates_to_utc(JSON.parse(structure)).to_json
    end
  end
end
