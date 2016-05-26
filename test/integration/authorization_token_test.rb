require "test_helper"

class AuthorizationTokenTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    2.times { create(:bucketlist, user_id: @user.id) }
  end

  test "user can access a bucketlist if he has a valid token" do
    post "/api/v1/auth/login", email: @user.email, password: @user.password
    @token = json(response.body)[:auth_token]
    get "/api/v1/bucketlists", {}, "Authorization" => @token
    assert_response 200
    bucketlist_count = json(response.body)[:bucketlist].count
    assert_equal @user.bucketlists.count, bucketlist_count
  end

  test "user cannot use an expired token" do
    token = JsonWebToken.encode({ user_id: @user.id }, 1.second.from_now.to_i)
    sleep 2
    get "/api/v1/bucketlists", {}, "Authorization" => token
    assert_response 401
    assert_equal language.expired_token, json(response.body)[:error]
  end

  test "user cannot use a bad token" do
    token = Faker::Lorem.characters(10)
    get "/api/v1/bucketlists", {}, "Authorization" => token
    assert_response 401
    assert_equal language.not_authenticated, json(response.body)[:error]
  end
end
