# frozen_string_literal: true

module Yams
  module Mq
    module Publisher
      class Warehouse < DscConnectivity::Mq::Publish::Base

        # Get access to the Rails's URL helpers for creating links to Artifacts
        include Rails.application.routes.url_helpers

        def publish(event, queue_name: nil)
          q = queue_name || connection_factory.q(key: :yams_warehouse)

          publish_message(event, queue_name: q)
        end

      end
    end
  end
end
