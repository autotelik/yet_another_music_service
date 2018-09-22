# frozen_string_literal: true

json.extract! license, :id, :name, :description, :url, :created_at, :updated_at
json.url license_url(license, format: :json)
