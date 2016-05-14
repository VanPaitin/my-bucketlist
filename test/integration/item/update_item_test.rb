require 'test_helper'

class Item::UpdateItemTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @item = create(:item, bucketlist_id: @bucketlist.id, done: false)
  end
  test "the truth" do

  end
end
