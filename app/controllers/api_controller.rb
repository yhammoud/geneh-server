class ApiController < ApplicationController
  require 'money'
  require 'monetize'
  require 'money/bank/google_currency'

  def get_exchange_rate
    Money.default_bank = Money::Bank::GoogleCurrency.new
    dollar = 1.to_money(:USD)
    @geneh = dollar.exchange_to(:EGP).to_f

    render json: @geneh
  end

  Thread.new() do
    while true
      Money.default_bank = Money::Bank::GoogleCurrency.new
      dollar = 1.to_money(:USD)
      @geneh = dollar.exchange_to(:EGP).to_f
      if Rate.last.nil?
        Rate.create(rate: @geneh)
      else
        last = Rate.last.rate
        if last > @geneh
          diff = (last - @geneh).to_f
          @text = "USD-EGP currency exchange rate is now %.2f, it has decreased by %.2f" %[@geneh, diff]
          @rate = Rate.last
          @rate.update(rate: @geneh)
          @rate.save!
          parameters = {
              "app_id" => "154d00fa-354b-4bba-a55b-9715f13b856d",
              "contents" => { "en" => @text},
              "included_segments" => ["All"]
          }
          # RestClient.post("https://onesignal.com/api/v1/notifications", parameters.to_json, :content_type => :json, :accept => :json)
          uri = URI.parse('https://onesignal.com/api/v1/notifications')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.path,
                                        'Content-Type'  => 'application/json',
                                        'Authorization' => "Basic ZTYyNzRiODgtMDYxYi00NGJjLTg3ZjAtMTdmNWFhMzhkNmY1")
          request.body = parameters.as_json.to_json
          response = http.request(request)
          puts response.body
        elsif last < @geneh
          diff = (@geneh - last).to_f
          @text = "USD-EGP currency exchange rate is now %.2f, it has increased by %.2f" %[@geneh, diff]
          @rate = Rate.last
          @rate.update(rate: @geneh)
          @rate.save!
          parameters = {
              "app_id" => "154d00fa-354b-4bba-a55b-9715f13b856d",
              "contents" => { "en" => @text},
              "included_segments" => ["All"]
          }
          # RestClient.post("https://onesignal.com/api/v1/notifications", parameters.to_json, :content_type => :json, :accept => :json)
          uri = URI.parse('https://onesignal.com/api/v1/notifications')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.path,
                                        'Content-Type'  => 'application/json',
                                        'Authorization' => "Basic ZTYyNzRiODgtMDYxYi00NGJjLTg3ZjAtMTdmNWFhMzhkNmY1")
          request.body = parameters.as_json.to_json
          response = http.request(request)
          puts response.body
        end
      end
      sleep 30
    end
  end
end

