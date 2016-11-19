require 'uri'
require 'net/http'
require 'net/http/digest_auth'
require 'json'

module LIVE_SERVER
  def self.create_application(application_name)
    digest_auth = Net::HTTP::DigestAuth.new

    uri = URI.parse "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/#{application_name}"
    uri.user = 'wowza'
    uri.password = 'i-827fbd24'

    payload = {
      "restURI": "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/#{application_name}",
      "name": "testlive",
      "appType": "Live",
      "clientStreamReadAccess": "*",
      "clientStreamWriteAccess": "*",
      "description": "Testing our Rest Service",
      "streamConfig": {
        "restURI": "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/#{application_name}/streamconfiguration",
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

