if Rails.application.credentials.youtube
  YoutubeSyncJob.perform_later
end