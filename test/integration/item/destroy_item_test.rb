require "test_helper"

class Item::DestroyItemTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @item = create(:item, bucketlist_id: @bucketlist.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "can delete a bucketlist item" do
    assert_equal 1, @bucketlist.items.count
    assert_difference "@bucketlist.items.count", -1 do
      delete "/api/v1/bucketlists/#{@bucketlist.id}/items/#{@item.id}",
             {}, @headers
    end
    assert_response 200
  end

  test "cannot delete a bucketlist item without authorization token" do
    delete "/api/v1/bucketlists/#{@bucketlist.id}/items/#{@item.id}"

    assert_response 401
    assert_equal language.not_authenticated, json(response.body)[:error]
  end
end
