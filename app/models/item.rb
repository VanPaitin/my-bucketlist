class Item < ActiveRecord::Base
  include TimeStamps
  belongs_to :bucketlist
  validates :name, presence: true
  validates :bucketlist_id, presence: true
end
