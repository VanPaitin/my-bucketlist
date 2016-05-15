require "test_helper"

class Item::CreateItemTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @bucketlist2 = create(:bucketlist, user_id: @user2.id)
    @item = create(:item, bucketlist_id: @bucketlist.id)
  end

  test "can create an item with the right values" do
    assert_equal 1, @bucketlist.items.count
    assert_difference "@bucketlist.items.count", 1 do
      ApplicationController.stub_any_instance(:current_user, @user) do
        post "/api/v1/bucketlists/#{@bucketlist.id}/items",
             { name: Faker::Lorem.paragraph, done: false }.to_json,
             "Content-Type" => "application/json"
      end
    end
    assert_equal 2, @bucketlist.items.count
    assert_response 201
    assert_equal Mime::JSON, response.content_type
  end

  test "cannot create an item with wrong credentials" do
    assert_no_difference "@bucketlist.items.count" do
      ApplicationController.stub_any_instance(:current_user, @user) do
        post "/api/v1/bucketlists/#{@bucketlist.id}/items",
             { name: "too short", done: false }.to_json,
             "Content-Type" => "application/json"
      end
    end
    assert_response 422
    assert_equal json(response.body)[:errors][:name],
                 ["is too short (minimum is 20 characters)"]
  end

  test "user cannot create item in another user's bucketlist" do
    assert_no_difference "Item.count" do
      ApplicationController.stub_any_instance(:current_user, @user) do
        post "/api/v1/bucketlists/#{@bucketlist2.id}/items",
             { name: Faker::Lorem.paragraph, done: false }.to_json,
             "Content-Type" => "application/json"
      end
    end
    assert !!@bucketlist2
    assert_response 404
    assert_equal json(response.body)[:null], "no bucketlist found"
  end
end
