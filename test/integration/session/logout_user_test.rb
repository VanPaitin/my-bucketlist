require "test_helper"

class LogoutUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "a logged in user can logout successfully" do
    assert @user.logged_in
    get "/api/v1/auth/logout", {}, @headers
    refute @user.reload.logged_in
    assert_response 200
    assert json(response.body)[:success].present?
    assert_equal json(response.body)[:success], "You are logged out now"
  end

  test "cannot logout if you are not logged in" do
    get "/api/v1/auth/logout"
    assert_response 401
  end
end
