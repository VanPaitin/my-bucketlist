require "test_helper"

class Item::DestroyItemTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @item = create(:item, bucketlist_id: @bucketlist.id)
  end

  test "can delete a bucketlist item" do
    assert_equal 1, @bucketlist.items.count
    ApplicationController.stub_any_instance(:current_user, @user) do
      assert_difference "@bucketlist.items.count", -1 do
        delete "/api/v1/bucketlists/#{@bucketlist.id}/items/#{@item.id}"
      end
    end
    assert_response 204
  end
end
