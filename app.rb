require 'sinatra/base'
require 'rack-flash'
require 'tilt/haml'
require 'padrino-helpers'
require 'aws-sdk'

require_relative 'helpers/app_helpers'

class Application < Sinatra::Base
  enable :sessions
  use Rack::Flash
  use Rack::MethodOverride
  register Padrino::Helpers
  helpers AppHelpers

  if ENV['AUTH_USERNAME'].present? && ENV['AUTH_PASSWORD'].present?
    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == ENV['AUTH_USERNAME'] && password == ENV['AUTH_PASSWORD']
    end
  end

  get '/' do
    @files = bucket.objects
    haml :index, layout: 'layout'
  end

  post '/files' do
    if params[:upload_files].present?
      obj = bucket.object(upload_file_name)
      obj.upload_file params[:upload_files][:tempfile],
                      content_type: params[:upload_files][:type]
      flash[:notice] = "Added file <strong>#{upload_file_name}</strong>.".html_safe
    else
      flash[:error] = "Please select a file to upload."
    end
    redirect to('/')
  end

  get '/files/:key' do |key|
    @item = bucket.object(CGI.unescape(key))
    haml :show, layout: 'layout'
  end

  delete '/files/:key' do |key|
    item = bucket.object(CGI.unescape(key))
    item.delete
    flash[:notice] = "Removed file <strong>#{CGI.unescape(key)}</strong>.".html_safe
    redirect to('/')
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
