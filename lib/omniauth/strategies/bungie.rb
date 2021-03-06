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
        raw_info.dig('bungieNetUser', 'membershipId')
      end

      info do
        info = raw_info['bungieNetUser'] || {}

        {
          :membership_id => info['membershipId'],
          :unique_name   => info['uniqueName'],
          :display_name  => info['displayName']
        }
      end

      extra { raw_info }

      def raw_info
        return @raw_info unless @raw_info.nil?

        @raw_info = access_token.get('/Platform/User/GetMembershipsForCurrentUser/').parsed
        @raw_info = (@raw_info['ErrorCode'] == 1) ? @raw_info['Response'] : {}
      end

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier,
                                   token_params.to_hash(symbolize_keys: true),
                                   deep_symbolize(options.auth_token_params))
      end
    end
  end
end
