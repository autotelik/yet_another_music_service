# frozen_string_literal: true

json.extract! album, :id, :title, :description, :user_id, :created_at, :updated_at
json.url album_url(album, format: :json)
