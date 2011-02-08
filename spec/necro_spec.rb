require 'config/application'
require 'rspec-rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'rails/all'

describe "ZOMBIES ARE COMING", :type => :acceptance do
  it "should run from zombies" do
    visit "/"
    response.should contain("rails")
  end
end
