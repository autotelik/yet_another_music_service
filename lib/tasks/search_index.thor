# frozen_string_literal: true

require_relative 'common/task_common'

module Yams

  class SearchIndex < Thor

    include TaskCommon
    desc :build, 'Build full Index for Elastic Search'

    def build
      load_rails_environment

      ::YamsCore::Artist.reindex
      ::YamsCore::Track.reindex
      ::YamsCore::Album.reindex
    end
  end

end
