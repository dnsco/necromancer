require 'config/application'
require 'rspec-rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'rails/all'

require "active_support/dependencies"

class Capybara::Driver::Necromancer < Capybara::Driver::Base
  attr_reader :app, :rack_server
  def initialize(app)
    @app = app
    @rack_server = Capybara::Server.new(@app)
    @rack_server.boot

  end

  def visit path
    @html = `curl -s #{rack_server.url(path)}`
  end

  def find(selector)
    html.xpath(selector).map { |node| Capybara::Driver::Node.new(self, node) }
  end

  def html
    Nokogiri::HTML(@html)
  end
end

Capybara.register_driver :necromancer do |app|
  Capybara::Driver::Necromancer.new(app)
end

Capybara.default_driver = :necromancer

describe "ZOMBIES ARE COMING", :type => :acceptance do
  it "should run from zombies" do
    visit "/"
    page.should_not have_content("sqlite3")
  end

  xit "should make JS calls" do
    visit "/"
    click_link "About your application’s environment"
    page.should have_content("sqlite3")
  end
end
