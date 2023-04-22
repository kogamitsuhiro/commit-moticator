require 'line/bot'
require 'dotenv'
Dotenv.load

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def send_line_message(text)
  message = {
    type: 'text',
    text: text
  }

  response = client.push_message(ENV["LINE_USER_ID"], message)
  puts "送信結果: #{response.code} #{response.body}"
end

send_line_message("毎日22時のメッセージです！")
