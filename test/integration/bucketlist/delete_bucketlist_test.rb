require "test_helper"

class DeleteBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @bucketlist2 = create(:bucketlist, user_id: @user2.id)
  end

  test "can delete a bucketlist" do
    assert_equal 2, Bucketlist.count
    ApplicationController.stub_any_instance(:current_user, @user) do
      assert_difference "Bucketlist.count", -1 do
        delete "/api/v1/bucketlists/#{@bucketlist.id}"
      end
    end
    assert_equal 204, response.status
  end

  test "cannot delete a bucketlist that belongs to another user" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      assert_no_difference "Bucketlist.count" do
        delete "/api/v1/bucketlists/#{@bucketlist2.id}"
      end
    end
    assert_response 404
  end
end
