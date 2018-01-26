# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл поддержки библиотеки factory_girl
#

require 'factory_girl'
require 'securerandom'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.definition_file_paths = ["#{$root}/spec/factories/"]
FactoryGirl.find_definitions
