class ValidationErrorSerializer
  def initialize(record, field, details)
    @record  = record
    @field   = field
    @details = details
  end

  def serialize
    {
      resource: underscored_resource_name,
      field:    @field.to_s,
      details:  details
    }
  end

  private

  def underscored_resource_name
    @record.class.to_s.gsub('::', '').underscore
  end
end
