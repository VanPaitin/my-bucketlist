require "test_helper"

class LogoutUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "user is logged_in" do
    assert @user.logged_in
  end

  test "a logged in user can logout successfully" do
    get "/api/v1/auth/logout", {}, @headers

    refute @user.reload.logged_in
    assert_response 200
    assert json(response.body)[:success].present?
    assert_equal json(response.body)[:success], language.logout
  end

  test "cannot logout if you are not logged in" do
    get "/api/v1/auth/logout"

    assert_response 401
    assert_equal language.not_authenticated, json(response.body)[:error]
  end
end
