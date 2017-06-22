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
        raw_info['membershipId']
      end

      info do
        {
          :membership_id => raw_info['membershipId'],
          :unique_name => raw_info['uniqueName'],
          :display_name => raw_info['displayName']
        }
      end

      extra { raw_info }

      def raw_info
        return @raw_info unless @raw_info.nil?

        @raw_info = access_token.get('/Platform/User/GetCurrentBungieNetUser/').parsed
        @raw_info = (@raw_info['ErrorCode'] == 1) ? @raw_info['Response'] : {}
      end
    end
  end
end
