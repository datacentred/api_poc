require 'test_helper'

module Harbour
  class ApplicationControllerTest < ApiTest
    test "redirects to docs when requested via HTML" do
      get "/api/"
      assert_redirected_to "/api/docs"
    end

    test "enforces content type to be JSON for payloads" do
      params = {role: {name: 'Staff', permissions: ["usage.read", "tickets.modify"]}}
      post '/api/roles', params: params.to_xml, headers: authorized_headers.merge("Content-Type" => "application/xml")
      assert_response :not_acceptable
      assert response_body["errors"][0]["detail"].include? 'json'
    end

    test "meaningful error for incorrect API versions" do
      get "/api/", params: { format: :dc_json }
      get '/api/roles', headers: authorized_headers.merge("Accept" => "application/vnd.datacentred.api+json; version=999999999")
      assert_response :not_acceptable
      assert response_body["errors"][0]["detail"].downcase.include? 'unknown api version'
    end
  end
end
