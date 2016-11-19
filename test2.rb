require 'uri'
require 'net/http'
require 'net/http/digest_auth'
require 'json'

uri = URI.parse 'http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive'
uri.user = 'wowza'
uri.password = 'i-827fbd24'

h = Net::HTTP.new uri.host, uri.port
h.set_debug_output $stderr

req = Net::HTTP::Post.new uri.request_uri

res = h.request req

digest_auth = Net::HTTP::DigestAuth.new
auth = digest_auth.auth_header uri, res['www-authenticate'], 'POST'

req = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json', 'Accept' => 'application/json')
req.add_field 'Authorization', auth
payload = {
  "restURI": "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive",
  "name": "testlive",
  "appType": "Live",
  "clientStreamReadAccess": "*",
  "clientStreamWriteAccess": "*",
  "description": "Testing our Rest Service",
  "streamConfig": {
    "restURI": "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive/streamconfiguration",
    "streamType": "live"
  }
}

req.body = payload.to_json

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request req
end
puts
puts "passed" if res.code == '200'
puts "failed" if res.code != '200'

