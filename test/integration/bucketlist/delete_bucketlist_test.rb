require "test_helper"

class DeleteBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @bucketlist2 = create(:bucketlist, user_id: @user2.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json",
                 "Authorization" => token }
  end

  test "can delete a bucketlist" do
    assert_equal 2, Bucketlist.count
    assert_difference "Bucketlist.count", -1 do
      delete "/api/v1/bucketlists/#{@bucketlist.id}", {}, @headers
    end
    assert_equal 200, response.status
    assert_equal "Bucketlist deleted successfully",
                 json(response.body)[:success]
  end

  test "cannot delete a bucketlist that belongs to another user" do
    assert_no_difference "Bucketlist.count" do
      delete "/api/v1/bucketlists/#{@bucketlist2.id}", {}, @headers
    end
    assert_response 404
  end
end
