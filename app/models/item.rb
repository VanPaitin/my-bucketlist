class Item < ActiveRecord::Base
  include TimeStamps
  belongs_to :bucketlist
end
