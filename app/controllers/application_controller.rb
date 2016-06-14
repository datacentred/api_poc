class ApplicationController < ActionController::API
  resource_description do
    formats [:json, :xml, :csv]
  end

  def respond_with(content)
    render json: content, content_type: Mime::Type.lookup_by_extension(:dc_json).to_s
  end
end
