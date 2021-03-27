class ApplicationController < ActionController::API
  
  rescue_from ActiveRecord::RecordNotFound do |e|
    head :not_found
  end

  protected

  def invalid_params(required=[])
    render status: 406, json: {
      error_message: "Missing Require Parameter",
      error_details: required
    }
  end

  def response_errors(record)
    errors = []
    record.errors.messages.each do |key,value|
      #Rails.logger.debug("RESPONSE ERROR: '#{key}': #{key.to_s.humanize.capitalize}: '#{value}'")
      if key == :base || (value.is_a?(Array) && value.first.is_a?(String) && value.first.start_with?(key.to_s.humanize.capitalize))
        key = ""
      else
        key = key.to_s.humanize
      end
      errors << "#{key} #{value.join(', ')}"
    end
    errors
  end

end
