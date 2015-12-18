ENV['RACK_ENV'] = 'test'
ENV['APP_TITLE'] = 'I HAZ BUCKET'

require_relative '../app'
require 'rspec'
require 'rack/test'

describe Application do
  include Rack::Test::Methods

  let(:objects) { [] }

  let(:file) do
    double( key: 'foobar.png', public_url: 'http://example.com/foobar.png' )
  end

  before do
    allow_any_instance_of(Application).to receive(:bucket)
      .and_return(double(objects: objects))
  end

  def app
    Application
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
end
