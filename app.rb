require 'sinatra/base'
require 'tilt/haml'
require 'padrino-helpers'
require 'aws-sdk'

class Application < Sinatra::Base
  register Padrino::Helpers

  get '/' do
    @files = bucket.objects
    haml :index
  end

  post '/images' do
    
  end

  def bucket
    @_bucket ||= Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
  end
end
