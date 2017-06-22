# Omniauth::Bungie::Oauth2

[![Gem Version](https://badge.fury.io/rb/omniauth-bungie-oauth2.svg)](https://badge.fury.io/rb/omniauth-bungie-oauth2)
[![Build Status](https://travis-ci.org/RuBAN-GT/omniauth-bungie-oauth2.svg?branch=master)](https://travis-ci.org/RuBAN-GT/omniauth-bungie-oauth2)

A Bungie OAuth2 strategy for Omniauth.

## Installation

Add this line to your application's Gemfile:

~~~~ruby
gem 'omniauth-bungie-oauth2'
~~~~

And then execute:

    $ bundle

## Usage

### Settings

For usage this gem You must create an application with authentication access on [Bungie.net](https://www.bungie.net/en/application).
You should set **Confidential** value in the `OAuth Client Type` field.

After this, you can integrate this strategy with your application. (More about A Bungie OAuth2 you can read on [Help page](https://www.bungie.net/en/Help/Article/45481))

**This provider uses four arguments:**

* `client_id` - OAuth client_id,
* `client_secret` - OAuth client_secret,
* `x_api_key` - API Key,
* `redirect_uri` - Redirect URL.

### Rails integration

For integration with Rails You have to setup your strategy configuration in `config/initializers/devise.rb`:

~~~~ruby
Devise.setup do |config|
  config.omniauth :bungie,
    'client_id',
    'client_secret',
    'x_api_key',
    'redirect_url'
end
~~~~

> You can also define it in initializers with `config.middleware.use OmniAuth::Builder`.

After this You should define omniauth callback in routes and controller.

**routes.rb:**

~~~~ruby
devise_for :users, :controllers => {
  :omniauth_callbacks => 'devise/omniauth_callbacks',
}
~~~~

**devise/omniauth_callbacks_controller.rb**

~~~~ruby
class Devise::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def bungie
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      @user.remember_me = true

      sign_in_and_redirect @user, :event => :authentication

      set_flash_message(:notice, :success, :kind => 'Bungie') if is_navigational_format?
    else
      session["devise.bungie_data"] = request.env["omniauth.auth"]

      redirect_to '/'
    end
  end
end
~~~~

Now You should define `from_omniauth` method in your `User` model:

~~~~ruby
def self.from_omniauth(auth)
  where(:uid => auth.uid).first_or_create do |user|
    user.membership_id = auth.info.membership_id
    user.display_name  = auth.info.display_name
    user.unique_name   = auth.info.unique_name
  end
end
~~~~

> Do not forget to specify model fields in your migration.

### Result

After all manipulation the `request.env["omniauth.auth"]` have the next fields:

* `uid` with BungieNetUser membershipId
* `info` with membershipId, uniqueName, displayName
* `extra` with [GetCurrentBungieNetUser](https://destinydevs.github.io/BungieNetPlatform/docs/UserService/GetCurrentBungieNetUser) result

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RuBAN-GT/omniauth-bungie-oauth2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Fireteam

If you want to fight with Oryx with me or create any interesting applications for Destiny, you can add me ([https://www.bungie.net/en/Profile/254/12488384](https://www.bungie.net/en/Profile/254/12488384)).
