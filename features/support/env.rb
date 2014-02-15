require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'site_prism'

Capybara.default_driver = :poltergeist
Capybara.app_host       = "https://github.com"
Capybara.run_server     = false # we're not using Rack::Test, so no need to launch a server

def use_google_chrome
  # in case you want to use Google Chrome.
  # NOTE: you will get a weird error about "no such session"
  # as of build 32.0.1700.107. I could not get this to go away.
  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.default_driver = :selenium_chrome
end

# allows us to parse github style repo references like "rails/rails"
class String
  def to_hub
    user, repo = self.split '/'

    raise "Github repository path must be in the form <user>/<project> (i.e. rails/rails)" unless user and repo

    { :user => user, :repo => repo }
  end
end
