require 'date'
require 'dotenv'
require 'line/bot'
require 'octokit'
require_relative '../config/user_list.rb'
Dotenv.load

def line_client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def github_client
  @github_client ||= Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])
end

def send_line_message(text)
  message = {
    type: 'text',
    text: text
  }

  response = line_client.push_message(ENV["LINE_USER_ID"], message)
  puts "送信結果: #{response.code} #{response.body}"
end

def user_contributeted_today?(user)
  today = Date.today
  contributions = github_client.user_events(user)
  contributions.any? { |event| event.type == 'PushEvent' && Date.parse(event.created_at.to_s) == today }
end

USER_LISTS.each do |user|
  if user_contributeted_today?(user)
    send_line_message("#{user}さんが今日コントリビュートしました!") 
  else
    puts "#{user}さんは今日はコントリビュートありませんでした。"
  end
end
