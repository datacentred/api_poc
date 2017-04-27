module Harbour
  class ValidationErrorSerializer

    def initialize(record, field, details)
      @record = record
      @field = field
      @details = details
    end

    def serialize
      {
        resource: resource,
        detail: error_message
      }.merge(field == "base" ? {} : {field: field})
    end

    private

    def resource
      I18n.t(
        underscored_resource_name,
        scope: [:resources],
        locale: :api,
        default: @record.class.to_s.downcase
      )
    end

    def field
       I18n.t(
        @field,
        scope: [:fields, underscored_resource_name],
        locale: :api,
        default: @field.to_s.downcase
      )
    end

    def detail
      I18n.t(
        @details[:error],
        scope: [:errors, :codes],
        locale: :api,
        default: @details[:error].to_s.humanize
      )
    end
    
    def underscored_resource_name
      @record.class.to_s.gsub('::', '').downcase.underscore
    end

    def error_message
      if field == "base"
        "#{detail.downcase.capitalize}."
      else
        "#{resource.titleize} #{field} #{detail.downcase}."
      end
    end
  end
end
