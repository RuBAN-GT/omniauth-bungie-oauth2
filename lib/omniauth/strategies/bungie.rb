module OmniAuth
  module Strategies
    class Bungie < OmniAuth::Strategies::OAuth2
      args [:client_id, :client_secret, :api_key, :redirect_uri]

      option :name, 'bungie'

      option :client_options, {
        :site => 'https://www.bungie.net',
        :authorize_url => '/en/oauth/authorize',
        :token_url => '/platform/app/oauth/token'
      }

      def client
        client_options = options.client_options.merge(
          :connection_opts => {
            :headers => { 'X-API-Key' => options.api_key }
          },
          :redirect_uri => options.redirect_uri
        )

        ::OAuth2::Client.new(
          options.client_id,
          options.client_secret,
          deep_symbolize(client_options)
        )
      end

      uid do
        raw_info['id']
      end

      info do
        {
          :membership_id => raw_info['membershipId'],
          :unique_name => raw_info['uniqueName']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/Platform/User/GetCurrentBungieNetUser/').parsed
      end
    end
  end
end
