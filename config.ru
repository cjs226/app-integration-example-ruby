require 'rubygems'
require 'bundler'
require 'json'

Bundler.require


# # sets root as the parent-directory of the current file
# set :root, File.dirname(__FILE__)
# # sets the view directory correctly
# set :views, Proc.new { File.join(root, 'app/views') }

# require './demo'
require './app/demoApi'

use Rack::Session::Cookie, :key => 'demo', :path => '/', :secret => 'secret'

# run Demo
run DemoApi
