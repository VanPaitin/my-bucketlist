require "test_helper"

class Item::CreateItemTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @bucketlist2 = create(:bucketlist, user_id: @user2.id)
    @item = create(:item, bucketlist_id: @bucketlist.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "can create an item with the right values" do
    assert_equal 1, @bucketlist.items.count
    assert_difference "@bucketlist.items.count", 1 do
      post "/api/v1/bucketlists/#{@bucketlist.id}/items",
           { name: Faker::Lorem.paragraph, done: false }.to_json, @headers
    end
    assert_equal 2, @bucketlist.items.count
    assert_response 201
    assert_equal Mime::JSON, response.content_type
  end

  test "cannot create an item without a name" do
    assert_no_difference "@bucketlist.items.count" do
      post "/api/v1/bucketlists/#{@bucketlist.id}/items",
           { name: "", done: false }.to_json, @headers
    end
    assert_response 422
    assert_equal json(response.body)[:errors][:name], ["can't be blank"]
  end

  test "user cannot create item in another user's bucketlist" do
    assert_no_difference "Item.count" do
      post "/api/v1/bucketlists/#{@bucketlist2.id}/items",
           { name: Faker::Lorem.paragraph, done: false }.to_json, @headers
    end
    refute @bucketlist2.nil?
    assert_response 404
    assert_equal json(response.body)[:null], "no bucketlist found"
  end
end
