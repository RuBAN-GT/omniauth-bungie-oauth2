module OmniAuth
  module Strategies
    class Bungie < OmniAuth::Strategies::OAuth2
      args [:client_id, :client_secret, :api_key]

      option :name, 'bungie'

      option :client_options, {
        :site => 'https://www.bungie.net/en',
        :authorize_url => 'oauth/authorize',
        :token_url => 'oauth/token'
      }

      def client
        client_options = options.client_options.merge(
          :connection_opts => {
            :headers => { 'X-API-Key' => options.api_key }
          }
        )

        ::OAuth2::Client.new(
          options.client_id,
          options.client_secret,
          deep_symbolize(client_options)
        )
      end
    end
  end
end
