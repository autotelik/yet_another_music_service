# frozen_string_literal: true

json.tracks @tracks_json

json.user_token current_user.id
json.client_token '0987654321' # TODO: - add tokens to devise

json.playlist @playlist.id
json.page '1'
json.total_pages  '1'
json.track '0'
json.position '0'
