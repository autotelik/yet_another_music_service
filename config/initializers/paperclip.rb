# Content Type Spoof issue

# Some genuine mp3 encodings give :
# [paperclip] Content Type Spoof: (audio/mpeg from Headers, ["audio/mpeg"] from Extension),
# content type discovered from file command: application/octet-stream.
#
# For now add this allow this combination - TODO better solution

#Paperclip.options[:content_type_mappings] = {
#    :mp3 => "application/octet-stream"
#}