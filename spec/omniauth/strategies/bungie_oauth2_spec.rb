require 'spec_helper'
require 'omniauth-bungie-oauth2/version'
require 'omniauth-bungie-oauth2'

describe OmniAuth::Strategies::Bungie do
  it "has a version number" do
    expect(OmniAuth::BungieOauth2::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
