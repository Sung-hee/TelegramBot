## Telegrambot에 weather API 추가하기

>### 이번에는 hellobot에 weather API을 이용해 날씨 기능을 추가합시다 !
>
> 
>
>#### 우리는 Yahoo Weather API를 쓰겠습니다 !
>
> 
>
>```ruby
>chat_text = hash["result"].last["message"]["text"]
>chat_id = hash["result"].last["message"]["from"]["id"]
>
>citys = ["서울", "인천", "부산", "대구", "김포"]
>
>chat_text.capitalize! # 소문자를 대문자로 !
>
># 야후 weather API 정보 요청
>weather_res = HTTParty.get("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22%EC%9D%B8%EC%B2%9C%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
>weather_hash = JSON.parse(weather_res.body)
>
># citys를 반복하면서 텍스트와 citys을 비교해서 똑같으면 sendMessage로 날씨 알려줌 !
>citys.each do |index|
>	if index == chat_text
>		city_weather = weather_hash["query"]["results"]["item"]["condition"]["text"]
>		city_msg = weather_hash["query"]["results"]["channel"]["location"]["city"]
>
>		encoded = URI.encode(city_weather + city_msg)
>		HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>	end
>end
>```
>
>
>
>
>
>

