require "test_helper"

class AuthorizationTokenTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    2.times { create(:bucketlist, user_id: @user.id) }
  end
  test "user cannot access a bucketlist resource without a valid token" do
    get "/api/v1/bucketlists"
    assert_response 401
  end

  test "user can access a bucketlist if he has a valid token" do
    post "/api/v1/auth/login", email: @user.email, password: @user.password
    @token = json(response.body)[:auth_token]
    get "/api/v1/bucketlists", {}, "Authorization" => @token
    assert_response 200
    bucketlist_count = json(response.body)[:bucketlist].count
    assert_equal @user.bucketlists.count, bucketlist_count
  end
end
