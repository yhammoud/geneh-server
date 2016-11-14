class NotificationController < ApplicationController
  require 'net/http'
  require 'certified'

  def new
  end

  def push
    # if rate increased
    text = ""
    # if rate decreased

    text = params["notification_text"]
    parameters = {
        "app_id" => "0129211f-1969-4f48-9705-c4a2de2017ef",
        "contents" => { "en" => text},
        "included_segments" => ["All"]
    }
    # RestClient.post("https://onesignal.com/api/v1/notifications", parameters.to_json, :content_type => :json, :accept => :json)
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type'  => 'application/json',
                                  'Authorization' => "Basic YjRkZDY3N2QtOTIyYy00OTQ2LTgzM2EtOTY5NjJmZDkyOGNh")
    request.body = parameters.as_json.to_json
    response = http.request(request)
    puts response.body
  end
end
