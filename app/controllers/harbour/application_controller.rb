module Harbour
  class ApplicationController < ActionController::API
    resource_description do
      formats [:json]
    end

    def respond_with(content)
      render json: content.as_json, content_type: Mime::Type.lookup_by_extension(:dc_json).to_s
    end
  end
end
