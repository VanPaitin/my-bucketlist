require "test_helper"

class UpdateUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @new_name = user.name
    @user2 = create(:user)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "can update user with the right credentials" do
    refute_equal @new_name, @user.name
    put "/api/users/#{@user.id}",
        { name: @new_name, email: user.email, password: user.password,
          password_confirmation: user.password_confirmation }.to_json,
        @headers
    assert_equal @new_name, @user.reload.name
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
  end

  test "user cannot update his account if he is not logged in" do
    put "/api/users/#{@user.id}",
        name: @new_name, email: user.email, password: user.password,
        password_confirmation: user.password_confirmation
    assert_response 401
  end

  test "cannot update user with invalid credentials" do
    put "/api/users/#{@user.id}",
        { name: "", email: user.email, password: user.password,
          password_confirmation: user.password_confirmation }.to_json,
        @headers
    assert_equal 422, response.status
    assert json(response.body)[:errors][:name].present?
  end

  test "cannot update another user" do
    put "/api/users/#{@user2.id}",
        { name: @user2.name, email: user.email, password: user.password,
          password_confirmation: user.password_confirmation }.to_json,
        @headers
    assert_equal 403, response.status
  end
end
