require "test_helper"

class Item::UpdateItemTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @item = create(:item, bucketlist_id: @bucketlist.id, done: false)
    @name = @item.name
    @done = @item.done
  end

  test "can update a bucketlist with the right credentials" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      put "/api/v1/bucketlists/#{@bucketlist.id}/items/#{@item.id}",
          name: Faker::Lorem.paragraph, done: true
    end
    assert_response 200
    refute_equal @name, @item.reload.name
    refute_equal @done, @item.reload.done
    assert_equal true, @item.reload.done
  end

  test "cannot update a bucketlist item with wrong credentials" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      put "/api/v1/bucketlists/#{@bucketlist.id}/items/#{@item.id}",
          name: Faker::Lorem.characters(19), done: true
    end
    assert_response 422
    assert_equal @name, @item.reload.name
    assert_equal @done, @item.reload.done
    assert_equal false, @item.reload.done
    item_result = json(response.body)
    assert_equal true, item_result[:errors].present?
    assert_equal true, item_result[:errors][:name].present?
    assert_equal json(response.body)[:errors][:name],
                 ["is too short (minimum is 20 characters)"]
    refute_equal true, item_result[:errors][:done].present?
  end
end
