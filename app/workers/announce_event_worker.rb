module Yams
  class AnnounceEventWorker
    include Sidekiq::Worker

    def perform(announcement_id)
      event = Announcement.find(announcement_id)

      # Write to MQ/Kafka
    end
  end

end
