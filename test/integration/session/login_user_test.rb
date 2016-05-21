require "test_helper"

class LoginUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, logged_in: false)
    @fake_password = Faker::Lorem.characters(10)
  end

  test "can log in a user successfully with right credentials" do
    assert_equal false, @user.logged_in
    post "/api/v1/auth/login",
         { email: @user.email, password: @user.password }.to_json,
         "Content-Type" => "application/json"
    assert_equal 200, response.status
    assert_equal @user.reload.logged_in, true
    assert_equal Mime::JSON, response.content_type
    assert_includes json(response.body)[:success], "Successfully logged in"
  end

  test "user cannot login with wrong password/wrong email" do
    post "/api/v1/auth/login",
         { email: @user.email, password: @fake_password }.to_json,
         "Content-Type" => "application/json"
    assert_response 422
    refute @user.reload.logged_in
    assert json(response.body)[:error].present?
    assert_equal json(response.body)[:error],
                 "invalid email/password combination"
  end

  test "cannot login with invalid parameters" do
    post "/api/v1/auth/login"
    assert_response 400
    assert_equal "please pass in a valid email address",
                 json(response.body)[:email]
  end
end
