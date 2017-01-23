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
        field: field,
        detail: "#{resource.titleize} #{field} #{detail.downcase}."
      }
    end

    private

    def resource
      I18n.t(
        underscored_resource_name,
        scope: [:resources],
        locale: :api,
        default: @record.class.to_s
      )
    end

    def field
       I18n.t(
        @field,
        scope: [:fields, underscored_resource_name],
        locale: :api,
        default: @field.to_s
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
      @record.class.to_s.gsub('::', '').underscore
    end
  end
end
