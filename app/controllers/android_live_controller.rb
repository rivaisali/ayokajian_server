class AndroidLiveController < AndroidAbstractController

  PRD_SERVER_HOST_ADDRESS = 'http://ec2-52-78-228-123.ap-northeast-2.compute.amazonaws.com'
  DEV_SERVER_HOST_ADDRESS = 'http://localhost'

  def create
    room_name = params[:room_name]
    if room_name.nil?
      raise Exceptions::ParameterNotFulfilled
    end

    last = Room.last
    if last != nil
      last_number = last.id
    else
      last_number = 1
    end

    new_application_name = last_number + 1
    new_application_name = new_application_name.to_s

    live_server = LIVE_SERVER::LiveServer.new
    res = live_server.create_application(new_application_name)
    if !res.code.eql? "201"
      raise Exceptions::CannotCreateRoom
    end

    # code == "409" duplicate app_name

    live_url = live_server.make_live_url(new_application_name)

    @room = Room.create(stream_url: live_url, room_name: room_name, app_name: new_application_name)
  end
end
