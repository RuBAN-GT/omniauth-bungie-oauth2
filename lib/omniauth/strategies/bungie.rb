require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Bungie < OmniAuth::Strategies::OAuth2
      # Arguments
      args [:api_key, :auth_url]

      # Options
      option :name, 'bungie'
      option :origin, nil

      # Update client with Faraday middleware & special authorize url.
      def client
        client_options = {
          :authorize_url => options.auth_url
        }.merge(options.client_options)

        ::OAuth2::BungieClient.new(nil, nil, deep_symbolize(client_options)) do |b|
          b.request :json

          b.adapter Faraday.default_adapter
        end
      end

      # Updated callback phase with new refreshing
      def callback_phase
        error = request.params["error_reason"] || request.params["error"]

        if error
          fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
        elsif !options.provider_ignores_state && (request.params["state"].to_s.empty? || request.params["state"] != session.delete("omniauth.state"))
          fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
        else
          self.access_token = build_access_token
          self.access_token = access_token.refresh!(token_params) if access_token.expired?

          super
        end
      rescue ::OAuth2::Error, CallbackError => e
        fail!(:invalid_credentials, e)
      rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
        fail!(:timeout, e)
      rescue ::SocketError => e
        fail!(:failed_to_connect, e)
      end

      #  Defining of Origin string
      def origin
        if options.origin === true
          request.base_url
        elsif options.origin.is_a? String
          options.origin
        else
          ''
        end
      end

      # Token params with X-Api-Key & Origin
      def token_params
        token_params = options.token_params.merge(options_for("token"))

        token_params[:headers]['X-Api-Key'] = options.api_key
        token_params[:headers]['Origin'] = origin unless options.origin.nil?

        token_params
      end

      # Get important data
      uid { raw_info.dig('bungieNetUser', 'membershipId') }
      info do
        destiny = raw_info['destinyAccounts']&.first

        {
          :membership_id => destiny.dig('userInfo', 'membershipId'),
          :membership_type => destiny.dig('userInfo', 'membershipType'),
          :display_name => destiny.dig('userInfo', 'displayName')
        } unless destiny.nil?
      end
      extra do
        {
          'raw_info' => raw_info
        }
      end
      def raw_info
        return @raw_info unless @raw_info.nil?

        @raw_info = access_token.get('/Platform/User/GetCurrentBungieAccount/', token_params).parsed

        @raw_info = @raw_info.dig('Response')
      end
    end
  end
end
