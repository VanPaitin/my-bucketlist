require "test_helper"

class ItemTest < ActiveSupport::TestCase
  should belong_to(:bucketlist)
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_least(20)
  should validate_presence_of(:bucketlist_id)
end
