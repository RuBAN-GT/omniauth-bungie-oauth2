require 'spec_helper'
require 'omniauth-bungie-oauth2'

describe Omniauth::Strategies::Bungie do
  it "has a version number" do
    expect(Omniauth::BungieOauth2::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
