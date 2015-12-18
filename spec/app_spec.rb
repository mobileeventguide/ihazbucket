ENV['RACK_ENV'] = 'test'
ENV['APP_TITLE'] = 'I HAZ BUCKET'

require_relative '../app'
require 'rspec'
require 'rack/test'

describe Application do
  include Rack::Test::Methods

  let(:objects) { [] }

  let(:file) do
    double( key: 'foobar.png', public_url: 'http://example.com/foobar.png',
            last_modified: Time.now )
  end

  before do
    allow_any_instance_of(Application).to receive_message_chain(:bucket, :objects)
      .and_return(objects)
    allow_any_instance_of(Application).to receive_message_chain(:bucket, :object)
      .and_return(file)
  end

  describe "GET '/'" do
    before { get '/' }

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to include('I HAZ BUCKET') }

    context 'with files' do
      let(:objects) { [file] }
      it { expect(last_response.body).to include('foobar.png') }
    end
  end

  describe "POST '/files'" do
    before do
      allow(file).to receive(:upload_file)
      post '/files', upload_files: { filename: 'foobar.png', type: 'image/png' }
    end

    it { expect(last_response).to be_redirect }
  end

  describe "GET '/files/:key'" do
    before { get '/files/foobar.png' }

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to include('foobar.png') }
    it { expect(last_response.body).to include('http://example.com/foobar.png') }
  end

  describe "DELETE '/files/:key'" do
    before do
      allow(file).to receive(:delete)
      post '/files/foobar.png', _method: 'delete'
    end

    it { expect(last_response).to be_redirect }
  end

  def app
    Application
  end
end
