require "test_helper"

class DeleteBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist)
    @bucketlist.update_attribute(:user_id, @user.id)
  end
  test "can delete a bucketlist" do
    assert_equal 1, Bucketlist.count
    ApplicationController.stub_any_instance(:current_user, @user) do
      assert_difference "Bucketlist.count", -1 do
        delete "/api/v1/bucketlists/#{@bucketlist.id}"
      end
    end
    assert_equal 204, response.status
  end
end
