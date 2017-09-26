require 'test_helper'

class ProxyControllerTest < ActionDispatch::IntegrationTest

  test "should proxy to example.com" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example', match_requests_on: [:uri]) do
      get "/projects/#{project.id}/proxy/index.html"
    end
  end
end