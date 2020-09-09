class Listing < ApplicationRecord
  validates :url, presence: true
  validates_uniqueness_of :url

  def self.create_from_collection(collection)
    collection.each do |item|
      Listing.create(item)
    end
  end
end
