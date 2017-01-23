module Harbour
  class ApplicationController < ActionController::API

    respond_to :json

    resource_description do
      formats [:json]
    end

    protected

    before_action :restrict_content_type

    def restrict_content_type
      render json: {msg:  'Content-Type must be application/json'}, status: 406 unless request.content_type == 'application/json'
    end

    def respond_with(content, args={})
      params = {json: content, content_type: Mime::Type.lookup_by_extension(:dc_json).to_s}
      render params.merge(args)
    end

    rescue_from ActiveRecord::RecordInvalid,  with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from StandardError,                with: :render_error_response

    def render_unprocessable_entity_response(exception)
      respond_with({
        message: "Validation Failed",
        errors: ValidationErrorsSerializer.new(exception.record).serialize
      }, status: :unprocessable_entity)
    end

    def render_not_found_response
      head :not_found
    end
    
    def render_error_response(exception)
      # Honeybadger.notify(exception)
      render json: { message: exception.message, code: exception.code }, status: exception.http_status
    end
  end
end
