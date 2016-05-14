class Item < ActiveRecord::Base
  include TimeStamps
  belongs_to :bucketlist
  validates :name, presence: true, length: { minimum: 20 }
  validates :bucketlist_id, presence: true
end
