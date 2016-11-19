# curl --digest -u "wowza:i-827fbd24" -X POST --header 'Accept:application/json; charset=utf-8' --header 'Content-type:application/json; charset=utf-8' http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive -d'
# {
#    "restURI": "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive",
#    "name": "testlive",
#    "appType": "Live",
#    "clientStreamReadAccess": "*",
#    "clientStreamWriteAccess": "*",
#    "description": "Testing our Rest Service",
#    "streamConfig": {
#       "restURI": "http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive/streamconfiguration",
#       "streamType": "live"
#    }
# }'

# require 'net/http'
# require 'net/http/digest_auth'
#
# digest_auth = Net::HTTP::DigestAuth.new
#
# uri = URI.parse 'http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087'
# uri.user = 'wowza'
# uri.password = 'i-827fbd24'
#
# req = Net::HTTP::Post.new(uri)
# req['Accept'] = 'application/json; charset=utf-8'
# req['Content-type'] = 'application/json; charset=utf-8'

require 'rest-client'

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

headers = {
  'Accept': 'application/json; charset=utf-8',
  'Content-Type': 'application/json; charset=utf-8',
}

url = 'http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/testlive'


@request = RestClient::Request.new(:user => 'wowza',
                                   :password => 'i-827fbd24',
                                   :method => :post,
                                   :url => url,
                                   :payload => payload)
@request.make_headers(:accept => 'application/json')
@request.make_headers(:content_type => 'application/json')

# @request.make_headers(:auth_type => :digest)
# @request.make_headers(:user => 'wowza')
# @request.make_headers(:password => 'i-827fbd24')

# resource = RestClient::Resource.new(:user => 'wowza', :password => 'i-827fbd24', :method => :post, :url => url, :payload => payload)
# resource.make_headers(:accept => 'json')
# resource.make_headers(:content_type => 'json')
# resource.make_headers(:auth_type => :digest)
# # @request.make_headers(:user => 'wowza')
# # @request.make_headers(:password => 'i-827fbd24')

@uri = URI(url)
@uri.user = 'wowza'
@uri.password = 'i-827fbd24'

# resource.post
begin
  digest_request = RestClient::Request.new(@request.args.merge!(auth_type: :digest))
  digest_request.send(:setup_credentials, @request)
  digest_request.execute
rescue Exception => e
  puts e
  # puts @request.log_response(resource)
end
# res = resource.post url, payload, @request
# puts res.code
