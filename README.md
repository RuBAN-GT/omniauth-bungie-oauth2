# Omniauth::Bungie::Oauth2

[![Gem Version](https://badge.fury.io/rb/omniauth-bungie-oauth2.svg)](https://badge.fury.io/rb/omniauth-bungie-oauth2)

A Bungie OAuth2 strategy for Omniauth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-bungie-oauth2'
```

And then execute:

    $ bundle

## Usage

For full usage this gem You must create an application on [Bungie.net](https://www.bungie.net/en/application).

After this, you can integrate this strategy with your application. (More about A Bungie OAuth2 you can read on [Help page](https://www.bungie.net/en/Help/Article/45481))

For example, you can add the middleware to a Rails application in `/config/application.rb`:

~~~ruby
config.middleware.use OmniAuth::Builder do
  provider :bungie,
    'x_api_key_from_bungie_app_settings',
    'authorization_url_from_bungie_app_settings',
    :origin => 'origin_url_if_you_need'
end
~~~~

After all manipulation the `request.env["omniauth.auth"]` have the next fields:

* `uid` with BungieNetUser membershipId
* `info` with Destiny membershipId, membershipType and displayName
* `extra` with [GetBungieAccount](https://destinydevs.github.io/BungieNetPlatform/docs/UserService/GetBungieAccount) result

## Configuration

This provider require two arguments and have one special option:

* `api_key` - X-Api-Key for Bungie API;
* `auth_url` - Autherization url;
* `origin` - Origin url;

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RuBAN-GT/omniauth-bungie-oauth2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Fireteam

If you want to fight with Oryx with me or create any interesting applications for Destiny, you can add me ([https://www.bungie.net/en/Profile/254/12488384](https://www.bungie.net/en/Profile/254/12488384)).
