require 'sinatra/base'
require 'tilt/haml'
require 'padrino-helpers'
require 'aws-sdk'

class Application < Sinatra::Base
  register Padrino::Helpers

  get '/' do
    @files = bucket.objects
    haml :index, layout: 'layout'
  end

  post '/files' do
    obj = bucket.object(upload_file_name)
    obj.upload_file(params[:upload_files][:tempfile])
    redirect to('/')
  end

  get '/files/:key' do
    @item = bucket.object(CGI.unescape(params[:key]))
    haml :show, layout: 'layout'
  end

  def self.protect_from_csrf
    false
  end

  private

  def bucket
    @_bucket ||= Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
  end

  def upload_file_name
    params[:upload_files][:filename]
  end
end
