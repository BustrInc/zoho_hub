# frozen_string_literal: true

module ZohoHub
  class Response
    def initialize(params)
      @params = params || {}
    end

    def invalid_data?
      error_code?('INVALID_DATA')
    end

    def invalid_token?
      error_code?('INVALID_TOKEN')
    end

    def internal_error?
      error_code?('INTERNAL_ERROR')
    end

    def authentication_failure?
      error_code?('AUTHENTICATION_FAILURE')
    end

    def invalid_module?
      error_code?('INVALID_MODULE')
    end

    def no_permission?
      error_code?('NO_PERMISSION')
    end

    def mandatory_not_found?
      error_code?('MANDATORY_NOT_FOUND')
    end

    def record_in_blueprint?
      error_code?('RECORD_IN_BLUEPRINT')
    end

    def empty?
      @params.empty?
    end

    def data
      data = nil
      # data from invoice.zoho.com.
      # returned under the module name, not 'data'
      if @params.present? && @params[:module_name].present?
        zoho_invoice_data = @params.find{|k,v| k =~ /#{@params[:module_name]}/i}
        data = zoho_invoice_data[1] if zoho_invoice_data.present?
      end
      # data from zohoCRM returned under 'data'
      data = @params[:data] if @params.dig(:data)
      puts @params.to_s
      puts '***** CWIK'
      puts data.to_s
      data || @params
    end

    def msg
      first_data = data.is_a?(Array) ? data.first : data
      msg = first_data[:message]

      if first_data.dig(:details, :expected_data_type)
        expected = first_data.dig(:details, :expected_data_type)
        field = first_data.dig(:details, :api_name)
        parent_api_name = first_data.dig(:details, :parent_api_name)

        msg << ", expected #{expected} for '#{field}'"
        msg << " in #{parent_api_name}" if parent_api_name
      end

      msg
    end

    # Error response examples:
    # {"data":[{"code":"INVALID_DATA","details":{},"message":"the id given...","status":"error"}]}
    # {:code=>"INVALID_TOKEN", :details=>{}, :message=>"invalid oauth token", :status=>"error"}
    def error_code?(code)
      if data.is_a?(Array)
        return false if data.size > 1

        return data.first[:code] == code
      end

      data[:code] == code
    end
  end
end
