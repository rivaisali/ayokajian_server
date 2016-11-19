require 'uri'
require 'net/http'
require 'net/http/digest_auth'
require 'json'

module LIVE_SERVER
  # API_SERVER_HOST_URL = "#{HOST_ADDRESS}:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/"
  # LIVE_SERVER_URL = "rtmp://#{HOST_ADDRESS}:1935/"

  class LiveServer
    attr_accessor :host, :user, :password, :api_server_url, :live_server_url

    def initialize
      data = LIVE_SERVER::Data.new
      @host = data.host
      @user = data.user
      @password = data.password

      @api_server_url = "http://#{@host}:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/"
      @live_server_url = "rtmp://#{@host}:1935/"
    end

    def make_live_url(applicaiton_name)
      live_server_url + applicaiton_name
    end

    def create_application(application_name)
      digest_auth = Net::HTTP::DigestAuth.new

      uri = URI.parse "#{@api_server_url}#{application_name}"
      uri.user = user
      uri.password = password

      payload = {
        "restURI": "#{api_server_url}#{application_name}",
        "name": "#{application_name}",
        "appType": "Live",
        "clientStreamReadAccess": "*",
        "clientStreamWriteAccess": "*",
        "description": "Testing our Rest Service",
        "streamConfig": {
          "restURI": "#{api_server_url}#{application_name}/streamconfiguration",
          "streamType": "live"
        }
      }


      h = Net::HTTP.new uri.host, uri.port
      h.set_debug_output $stderr

      req = Net::HTTP::Get.new uri.request_uri, 'Content-Type' => 'application/json', 'Accept' => 'application/json'

      res = h.request req
# res is a 401 response with a WWW-Authenticate header

      auth = digest_auth.auth_header uri, res['www-authenticate'], 'POST'

# create a new request with the Authorization header
      req = Net::HTTP::Post.new uri.request_uri, 'Content-Type' => 'application/json', 'Accept' => 'application/json'
      req.add_field 'Authorization', auth
      req.body = JSON.dump(payload)

# re-issue request with Authorization
      res = h.request req
      res
    end
  end


end

