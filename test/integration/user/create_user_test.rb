require "test_helper"

class CreateUserTest < ActionDispatch::IntegrationTest
  setup { @name = user.name }
  test "can successfully create a user with valid credentials" do
    assert_difference "User.count", 1 do
      post "/api/users", { name: @name, email: user.email,
                           password: user.password, password_confirmation: user.
                             password_confirmation }.to_json,
           "Content-Type" => "application/json"
    end
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    assert_equal json(response.body)[:success], "Successfully created"
  end
  test "user creation failure with invalid credentials" do
    assert_no_difference "User.count" do
      post "/api/users", { name: "", email: user.email,
                           password: user.password, password_confirmation: user.
                             password_confirmation }.to_json,
           "Content-Type" => "application/json"
    end
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 6 characters)"
  end
end
