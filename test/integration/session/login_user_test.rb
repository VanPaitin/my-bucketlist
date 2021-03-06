require "test_helper"

class LoginUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, logged_in: false)
    @fake_password = Faker::Lorem.characters(10)
  end

  test "user is not logged_in" do
    refute @user.logged_in
  end

  test "can log in a user successfully with right credentials" do
    post "/api/v1/auth/login",
         { email: @user.email, password: @user.password }.to_json,
         "Content-Type" => "application/json"

    assert_equal 200, response.status
    assert_equal @user.reload.logged_in, true
    assert_equal Mime::JSON, response.content_type
    assert_includes json(response.body)[:success], language.login
  end

  test "user cannot login with wrong password/wrong email" do
    post "/api/v1/auth/login",
         { email: @user.email, password: @fake_password }.to_json,
         "Content-Type" => "application/json"

    assert_response 422
    refute @user.reload.logged_in
    assert json(response.body)[:error].present?
    assert_equal json(response.body)[:error], language.wrong_email_or_password
  end
end
