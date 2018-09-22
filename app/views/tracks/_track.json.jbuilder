# frozen_string_literal: true

json.extract! track, :id, :title, :description, :length, :shared, :streamable, :downloadable, :permalink, :bitrate, :played, :downloaded, :favourited, :commented, :release_year, :release_month, :release_day, :original_format, :original_content_size, :stream_url, :download_url, :user_id, :license_id, :id3_genre_id, :created_at, :updated_at
json.url track_url(track, format: :json)
