require 'test_helper'

module Harbour
  class Target
    include Harbour::Sortable
  end
  class SortableTest < Minitest::Test
    def setup
      @target = Target.new
    end

    def test_sort_alphabetically_hash
      assert_equal "{:bar=>\"bar\", :foo=>\"foo\"}", @target.sort_alphabetically({foo: "foo", bar: "bar"}).to_s
    end

    def test_sort_alphabetically_array
      assert_equal "[\"bar\", \"foo\"]", @target.sort_alphabetically(["foo", "bar"]).to_s
    end

    def test_sort_alphabetically_string
      assert_equal "foo", @target.sort_alphabetically("foo")
    end

    def test_sort_alphabetically_hash_with_nested_array
      structure = {
        foo: ["foo", "bar"],
        bar: "bar"
      }
      assert_equal "{:bar=>\"bar\", :foo=>[\"bar\", \"foo\"]}", @target.sort_alphabetically(structure).to_s
    end

    def test_sort_alphabetically_array_with_nested_hashes
      structure = [
        {
          foo: ["foo", "bar"],
          bar: "bar"
        },
        {
          foo: ["foo", "bar"],
          bar: "bar"
        },
        "foo"
      ]
      assert_equal "[{:bar=>\"bar\", :foo=>[\"bar\", \"foo\"]}, {:bar=>\"bar\", :foo=>[\"bar\", \"foo\"]}, \"foo\"]", @target.sort_alphabetically(structure).to_s
    end
  end
end
