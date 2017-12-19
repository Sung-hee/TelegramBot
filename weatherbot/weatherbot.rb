require 'httparty'
require 'awesome_print'
require 'json'
require 'uri'
require 'nokogiri'

url = "https://api.telegram.org/bot"
token = "494505815:AAEr9hM4tekek6fYfA03-6n7emUC5vdbjcE"
response = HTTParty.get("#{url}#{token}/getUpdates")
hash = JSON.parse(response.body)

hi_text = ["ㅎㅇ", "안녕", "hi", "반가워", "하이"]
end_text = "종료"
chat_update = hash["result"].last["update_id"]
citys = ["서울", "인천", "부산", "대구", "김포"]

while true

  response = HTTParty.get("#{url}#{token}/getUpdates")
  hash = JSON.parse(response.body)
  new_update = hash["result"].last["update_id"]

  if new_update > chat_update
    # pooling 방법
    chat_text = hash["result"].last["message"]["text"]
    chat_id = hash["result"].last["message"]["from"]["id"]

    chat_text.capitalize!
    weather_res = HTTParty.get("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22%EC%9D%B8%EC%B2%9C%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
    weather_hash = JSON.parse(weather_res.body)

    # 날씨
    citys.each do |index|
      if index == chat_text
        city_weather = weather_hash["query"]["results"]["item"]["condition"]["text"]
        city_msg = weather_hash["query"]["results"]["channel"]["location"]["city"]

        encoded = URI.encode(city_weather + city_msg)
        HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")

      end
    end

    # 인사말
    hi_text.each do |index|
      if index == chat_text
         msg = "안녕하세요"
         encoded = URI.encode(msg)

         HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
       end
     end

    chat_update = new_update

  elsif hash["result"].last["message"]["text"] == end_text
    msg_end = "종료합니다"
    encoded_end = URI.encode(msg_end)

    HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_end}")

    puts "종료합니다"
    break
  end
end
