class Announcement < ApplicationRecord

  enum status: %i[pending processed]
  enum category: %i[product payment billing]

end
