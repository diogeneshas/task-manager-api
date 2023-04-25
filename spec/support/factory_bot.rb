# RSpec
# spec/support/factory_bot.rb
require "factory_bot"

RSpec.configure { |config| config.include FactoryBot::Syntax::Methods }
