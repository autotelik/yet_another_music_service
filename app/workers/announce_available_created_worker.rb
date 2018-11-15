module Yams
  class AnnounceAvailableCreatedWorker
    include Sidekiq::Worker

    def perform(available_id)
      available = Available.find(available_id)

      # Publish Create Event to MQ
      #
      if available.free?

        # TODO - how do we pick this for a specific task??
        stream_name = "warehouse"

        event = ItemAvailableForFree.new(data: {
          available_id: available_id,
          order_data: "sample"
        })

        # Publishing an event for a specific stream
        event_store.publish(event, stream_name: stream_name)

        # TODO: Is this the right palce to do this ? or do we drive this from the Event Steo somehow ?
        # TODO: feels like that would require further hooks or observers ?
        #
        Yams::Mq::Publisher::Warehouse.publish(event)
      end

      if availble.commercial?
        # create ItemAvailableForCommericalEvent
      end

      if availble.playlist?
        # create ItemAvailableForPlaylistEvent
      end

      if availble.download?
        # create ItemAvailableForCommericalEvent
      end

    end
  end

end
