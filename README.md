## Telegram Bot

#### 이번에는 Telegram API를 이용하여 챗봇을 만들어 봅시다 !

<**이걸 하기전에 Ruby_lion에서 Telegram Bot 연습 문제들을 공부하고 오면 좋습니다 !**>



>**우선 Telegram Bot을 쓰기 위해서 아래와 같이 따라합니다.**
>
>BotFather를 실행 후 
>
>1. /newbot Heesk 입력 후 Heesk란 봇프로그램 만들기. 
>2. 이후 봇의 이름을 정해주자 => heees_bot 
>   그러면 Telegram에서 봇 API의 토큰을 준다 !
>3. 봇에게 텍스트를 보낸 후 https://api.telegram.org/bot"토큰"/getUpdates을 통해 결과를 확인하자
>4. 봇으로 사용자에게 텍스트를 보내고 싶다면
>   https://api.telegram.org/bot"토큰"/sendmessage?chat_id="사용자id"&text="텍스트"
>5. 결과값은 웹페이지에 json 형식으로 받아오는데 !
>   보기 편하고 싶다면 크롬 확장프로그램에 json viewer를 다운받아 보자 !
>6. 이것만 하면 됨...



#### 이번에는 텍스트에 인사말이 입력되면 인사해주는 Bot 을 만들겠습니다 !

>  ```ruby
>  require 'httparty'
>  require 'awesome_print'
>  require 'json'
>  require 'uri'
>  require 'nokogiri'
>
>  url = "https://api.telegram.org/bot"
>  token = "494505815:AAEr9hM4tekek6fYfA03-6n7emUC5vdbjcE"
>  response = HTTParty.get("#{url}#{token}/getUpdates")
>  hash = JSON.parse(response.body)
>
>  hi_text = ["ㅎㅇ", "안녕", "hi", "반가워", "하이"]
>  end_text = "종료"
>  chat_update = hash["result"].last["update_id"]
>
>  while true
>   # 여기서 리프래쉬 해줘야 한다.
>   # 안하면 update_id.last 가 업데이트가 안되서 
>   # update_id의 인덱스가 변하지 않아 if문이 성립이 안되고
>   # 무한루프에 빠지게 된다...
>   response = HTTParty.get("#{url}#{token}/getUpdates")
>   hash = JSON.parse(response.body)
>
>   new_update = hash["result"].last["update_id"]
>
>   if new_update > chat_update
>     # pooling 방법
>     chat_text = hash["result"].last["message"]["text"]
>     chat_id = hash["result"].last["message"]["from"]["id"]
>
>     hi_text.each do |index|
>       if index == chat_text
>
>          msg = "안녕하세요"
>          encoded = URI.encode(msg)
>
>          HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>       end
>     end
>     chat_update = new_update
>   elsif hash["result"].last["message"]["text"] == end_text
>     msg_end = "종료합니다"
>     encoded_end = URI.encode(msg_end)
>
>     HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_end}")
>     puts "종료합니다"
>     break
>   end
>  end
>  ```
>

### 앞으로는 여기에 계속 기능을 추가하여 확장할 예정임 ! 커밍순 !

#### 오늘은 이만 ! 

