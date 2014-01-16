# Rails.root/config.ru
require ::File.expand_path('../config/environment',  __FILE__)
 
# use Rack::Debugger
# use Rack::ContentLength
# run Rails.application

run ActionController::Dispatcher.new
