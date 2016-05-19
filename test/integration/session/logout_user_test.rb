require "test_helper"

class LogoutUserTest < ActionDispatch::IntegrationTest
  setup { @user = create(:user, logged_in: true) }

  test "a logged in user can logout successfully" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      assert @user.logged_in
      get "/api/v1/auth/logout"
    end
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
