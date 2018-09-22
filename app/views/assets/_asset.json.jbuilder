# frozen_string_literal: true

json.extract! asset, :id, :title, :original_format, :owner_id, :owner_type, :position, :user_id, :created_at, :updated_at
json.url asset_url(asset, format: :json)
