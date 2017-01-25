module OAuth2
  class BungieClient < Client
    def initialize(client_id, client_secret, options = {}, &block)
      opts = options.dup
      @id = client_id
      @secret = client_secret
      @site = opts.delete(:site)
      ssl = opts.delete(:ssl)
      @options = {
        :authorize_url     => 'https://www.bungie.net',
        :token_url         => 'https://www.bungie.net/Platform/App/GetAccessTokensFromCode',
        :refresh_token_url => 'https://www.bungie.net/Platform/App/GetAccessTokensFromRefreshToken',
        :token_method      => :post,
        :connection_opts   => {},
        :connection_build  => block,
        :max_redirects     => 5,
        :raise_errors      => true}.merge(opts)
      @options[:connection_opts][:ssl] = ssl if ssl
    end

    def get_token(params, access_token_opts = {}, access_token_class = BungieAccessToken)
      opts = {:raise_errors => options[:raise_errors], :parse => params.delete(:parse)}

      if options[:token_method] == :post
        headers = params.delete(:headers)
        opts[:body] = params
        opts[:headers] = {'Content-Type' => 'application/json'}
        opts[:headers].merge!(headers) if headers
      else
        opts[:params] = params
      end

      response = request(options[:token_method], token_url, opts)

      error = Error.new(response)

      response = get_normalized_response(response)

      raise(error) if options[:raise_errors] && !(response.is_a?(Hash) && response['access_token'])

      access_token_class.from_hash(self, response.parsed.merge(access_token_opts))
    end

    def get_token_with_refresh(params, access_token_opts = {}, access_token_class = BungieAccessToken)
      opts = {:raise_errors => options[:raise_errors], :parse => params.delete(:parse)}

      if options[:token_method] == :post
        headers = params.delete(:headers)
        opts[:body] = params
        opts[:headers] = {'Content-Type' => 'application/json'}
        opts[:headers].merge!(headers) if headers
      else
        opts[:params] = params
      end

      response = request(
        options[:token_method],
        connection.build_url(options[:refresh_token_url]).to_s,
        opts
      )

      error = Error.new(response)

      response = get_normalized_response(response)

      raise(error) if options[:raise_errors] && !(response.is_a?(Hash) && response['access_token'])

      access_token_class.from_hash(self, response.parsed.merge(access_token_opts))
    end

    def get_normalized_response(response)
      response = response.parsed

      return nil unless response.is_a?(Hash)

      if response['ErrorCode'] == 1 && !response.dig('Response', 'accessToken').nil?
        {
          :access_token => response.dig('Response', 'accessToken', 'value'),
          :token_type => 'Bearer',
          :expires_in => response.dig('Response', 'accessToken', 'expires'),
          :refresh_token => response.dig('Response', 'refreshToken', 'value'),
          :refresh_expries_in => response.dig('Response', 'refreshToken', 'expires')
        }
      else
        response
      end
    end
  end
end
