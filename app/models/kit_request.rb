class KitRequest < ApplicationRecord
  validates_presence_of :full_name
  validates_presence_of :address
end
