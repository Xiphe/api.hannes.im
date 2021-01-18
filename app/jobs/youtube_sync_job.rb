require 'net/http'
require 'uri'
require 'json'

class YoutubeSyncJob < ApplicationJob
  queue_as :default

  PLATFORM = 'youtube'

  def perform
    @db_videos = Video.all
    @existing_ids = []
    load_videos

    @db_videos.each do |video|
      if video.platform == PLATFORM && !@existing_ids.include?(video.foreign_id)
        video.destroy
      end
    end
  end

  private 
    def load_videos(page="")
      key = Rails.application.credentials.youtube[:api_key]
      channels = Rails.application.credentials.youtube[:channels]
  
      url = "https://www.googleapis.com/youtube/v3/search?key=#{key}&channelId=#{channels[0]}&type=video&part=snippet,id&order=date&maxResults=20&pageToken=#{page}"
      response = Net::HTTP.get URI(url)
      data = JSON.parse(response)

      unless data['items'] && data['items'].kind_of?(Array)
        return
      end
      
      data['items'].each do |video|
        sync_video video
      end

      if data['nextPageToken']
        load_videos data['nextPageToken']
      end
    end

    def sync_video(video)
      id = video['id']['videoId']
      @existing_ids.push id
      db_video = @db_videos.detect { |dbv| dbv.platform == PLATFORM && dbv.foreign_id == id } || Video.new 

      db_video.title = video['snippet']['title']
      db_video.thumbnail = video['snippet']['thumbnails']['high']['url']
      db_video.description = video['snippet']['description']
      db_video.url = "https://www.youtube.com/watch?v=#{id}"
      db_video.foreign_id = id
      db_video.platform = PLATFORM
      db_video.published_at = video['snippet']['publishedAt']
      
      db_video.save
    end
end
