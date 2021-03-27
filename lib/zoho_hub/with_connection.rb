# frozen_string_literal: true

module ZohoHub
  # Adds the ability to do API requests (GET / PUT and POST requests) when included in a class.
  module WithConnection
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def get(path, params = {}, use_zoho_invoice=false)
        ZohoHub.connection.get(path, params, use_zoho_invoice)
      end

      def post(path, params = {}, use_zoho_invoice=false)
        ZohoHub.connection.post(path, params, use_zoho_invoice)
      end

      def put(path, params = {}, use_zoho_invoice=false)
        ZohoHub.connection.put(path, params, use_zoho_invoice)
      end

      def delete(path, params = {}, use_zoho_invoice=false)
        ZohoHub.connection.delete(path, params, use_zoho_invoice)
      end
    end

    def get(path, params = {}, use_zoho_invoice=false)
      self.class.get(path, params, use_zoho_invoice)
    end

    def post(path, params = {}, use_zoho_invoice=false)
      self.class.post(path, params, use_zoho_invoice)
    end

    def put(path, params = {}, use_zoho_invoice=false)
      self.class.put(path, params, use_zoho_invoice)
    end

    def delete(path, params = {}, use_zoho_invoice=false)
      self.class.delete(path, params, use_zoho_invoice)
    end
  end
end
