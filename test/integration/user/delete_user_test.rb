require "test_helper"

class User::DeleteUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "user requires authorization to delete his account" do
    assert_no_difference "User.count" do
      delete "/api/users/#{@user.id}"
    end
    assert_response 401
    assert_equal language.not_authenticated, json(response.body)[:error]
  end

  test "user can delete his account" do
    assert_equal User.count, 2
    assert_difference "User.count", -1 do
      delete "/api/users/#{@user.id}", {}, @headers
    end
  end

  test "user cannot delete an account that is not his own" do
    assert_equal User.count, 2
    assert_no_difference "User.count" do
      delete "/api/users/#{@user2.id}", {}, @headers
    end
    assert_response 403
  end
end
