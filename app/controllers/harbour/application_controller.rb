module Harbour
  class ApplicationController < ActionController::API

    resource_description do
      formats [:json]
    end

    protected

    def respond_with(content, args={})
      params = {json: content, content_type: Mime::Type.lookup_by_extension(:dc_json).to_s}
      render params.merge(args)
    end

    rescue_from ActiveRecord::RecordInvalid,  with: :render_unprocessable_entity_response

    def render_unprocessable_entity_response(exception)
      render json: {
        errors: ValidationErrorsSerializer.new(exception.record).serialize
      }, status: :unprocessable_entity
    end

  end
end
