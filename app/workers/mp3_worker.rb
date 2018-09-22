class Mp3Worker
  include Sidekiq::Worker

  def perform(track_id)
    track = Track.find(track_id)

    logger.info "Process #{track} MP3 properties"
    track.update(length: Yams::Mp3PropertiesService.length(track.audio)) unless track.length.present?
  end

end
