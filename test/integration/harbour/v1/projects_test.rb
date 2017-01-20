require 'test_helper'

module Harbour
  module V1
    class ProjectsTest < ApiTest
      test "api user must be authorized to access projects" do
        assert_resource_is_unauthorized "projects"
      end
    end
  end
end
