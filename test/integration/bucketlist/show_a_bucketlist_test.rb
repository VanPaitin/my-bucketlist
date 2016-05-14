require "test_helper"

class ShowABucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    @bucketlist = create(:bucketlist)
    @bucketlist.update_attribute(:user_id, @user.id)
  end

  test "a user can only show his bucketlist" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      get "/api/v1/bucketlists/#{@bucketlist.id}"
    end
    assert_equal 200, response.status
    bucket_list_response = json(response.body)
    assert_equal @bucketlist.name, bucket_list_response[:name]
  end

  test "a user will not see a bucketlist that does not belong to him" do
    ApplicationController.stub_any_instance(:current_user, @user2) do
      get "/api/v1/bucketlists/#{@bucketlist.id}"
    end
    assert_equal 404, response.status
  end

  test "only logged in user can assess the bucketlist resource" do
    ApplicationController.stub_any_instance(:current_user, nil) do
      get "/api/v1/bucketlists/#{@bucketlist.id}"
    end
    assert_response 401
  end
end
