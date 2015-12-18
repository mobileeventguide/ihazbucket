require 'rubygems'
require 'bundler'

Bundler.require

if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
end

require './app'
run Application
