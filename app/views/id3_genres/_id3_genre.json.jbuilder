# frozen_string_literal: true

json.extract! id3_genre, :id, :name, :created_at, :updated_at
json.url id3_genre_url(id3_genre, format: :json)
