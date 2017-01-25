module OAuth2
  class BungieAccessToken < AccessToken
    # Updated refreshing method for a special bungie page
    def refresh!(params = {})
      raise('A refresh_token is not available') unless refresh_token

      params[:client_id]     = @client.id
      params[:client_secret] = @client.secret
      params[:grant_type]    = 'refresh_token'
      params[:refresh_token] = refresh_token
      params[:refreshToken]  = params[:refresh_token]

      new_token = @client.get_token_with_refresh(params)
      new_token.options = options
      new_token.refresh_token = refresh_token unless new_token.refresh_token
      new_token
    end
  end
end
