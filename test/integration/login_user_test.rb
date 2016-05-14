require "test_helper"

# class LoginUserTest < ActionDispatch::IntegrationTest
#   setup { @user = create(:user) }
#   test "can log in a user successfully" do
#     post "/api/v1/auth/login", { email: @user.email, password: @user.password }.
#       to_json, "Content-Type" => "application/json"
#     assert_equal 200, response.status
#     assert_equal Mime::JSON, response.content_type
#     assert_includes JSON.parse(response.body, symbolize_names: true)[
#       :success], "Successfully logged in"
#   end
# end
