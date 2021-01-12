require 'net/http'
require 'uri'
require 'json'

class YoutubeController < ApplicationController
  def index
    key = Rails.application.credentials.youtube[:api_key]
    channels = Rails.application.credentials.youtube[:channels]

    response = Net::HTTP.get URI(
      "https://www.googleapis.com/youtube/v3/search?key=#{key}&channelId=#{channels[0]}&type=video&part=snippet,id&order=date&maxResults=20&pageToken=#{params[:page]}"
    )
    @data = JSON.parse(response)
  end
end
