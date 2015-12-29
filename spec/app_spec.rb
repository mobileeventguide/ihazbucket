ENV['RACK_ENV'] = 'test'
ENV['APP_TITLE'] = 'I HAZ BUCKET'

require_relative '../app'
require 'rspec'
require 'rack/test'

describe Application do
  include Rack::Test::Methods

  let(:bucket) { double(objects: objects) }

  let(:objects) { [] }

  let(:object) do
    double( key: 'foobar.png', public_url: 'http://example.com/foobar.png',
            last_modified: Time.now, content_type: 'image/png', exists?: false )
  end

  let(:object_summary) do
    double( key: 'foobar.png', public_url: 'http://example.com/foobar.png',
            last_modified: Time.now, object: object )
  end

  before do
    allow_any_instance_of(Application).to receive(:bucket).and_return(bucket)
    allow(bucket).to receive(:object).and_return(object)
  end

  describe "GET '/'" do
    before { get '/' }

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to include('I HAZ BUCKET') }

    context 'with files' do
      let(:objects) { [object_summary] }
      it { expect(last_response.body).to include('foobar.png') }
    end
  end

  describe "POST '/files'" do
    before { allow(object).to receive(:upload_file) }

    it 'responds with a redirect' do
      post '/files', upload_files: { filename: 'foobar.png', type: 'image/png' }
      expect(last_response).to be_redirect
    end

    context 'duplicate filename' do
      before do
        allow(bucket).to receive(:object).with('foobar.png')
          .and_return(double(exists?: true))
      end

      it 'should add suffix to filename' do
        expect(bucket).to     receive(:object).with('foobar_1.png')
        expect(bucket).to_not receive(:object).with('foobar_2.png')
        post '/files', upload_files: { filename: 'foobar.png', type: 'image/png' }
      end
    end
  end

  describe "GET '/files/:key'" do
    before { get '/files/foobar.png' }

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to include('foobar.png') }
    it { expect(last_response.body).to include('http://example.com/foobar.png') }
  end

  describe "DELETE '/files/:key'" do
    before do
      allow(object).to receive(:delete)
      post '/files/foobar.png', _method: 'delete'
    end

    it { expect(last_response).to be_redirect }
  end

  def app
    Application
  end
end
