require "test_helper"

class User::ShowUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "user cannot see his page if he is not logged in" do
    get "/api/users/#{@user.id}"
    assert_response 401
  end

  test "user can see his profile page if he has a token" do
    get "/api/users/#{@user.id}", {}, @headers
    assert_equal 200, response.status
    user_response = json(response.body)
    assert_equal @user.name, user_response[:name]
    assert_equal @user.email, user_response[:email]
  end

  test "cannot see another user's page" do
    get "/api/users/#{@user2.id}", {}, @headers
    assert_equal 403, response.status
  end
end
