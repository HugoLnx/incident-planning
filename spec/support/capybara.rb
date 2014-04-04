require 'capybara/rspec'
require 'capybara/poltergeist'
require "timeout"

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

def wait_until
  Timeout.timeout(Capybara.default_wait_time) do
    sleep(0.1) until value = yield
    value
  end
end
