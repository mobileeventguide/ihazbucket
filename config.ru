require 'rubygems'
require 'bundler'

Bundler.require

require 'dotenv'
Dotenv.load

require './app'
run Application
