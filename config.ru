require 'bundler'
Bundler.require

require 'rack-livereload'
use Rack::LiveReload


require './app'
run Sinatra::Application
