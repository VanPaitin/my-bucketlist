require 'test_helper'

class User::DeleteUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
  end
  test "user can delete his account" do
    assert_equal User.count, 2
    assert_difference "User.count", -1 do
      ApplicationController.stub_any_instance(:current_user, @user) do
        delete "/api/users/#{@user.id}"
      end
    end
  end
  test "user cannot delete an account that is not his own" do
    assert_equal User.count, 2
    assert_no_difference "User.count" do
      ApplicationController.stub_any_instance(:current_user, @user2) do
        delete "/api/users/#{@user.id}"
      end
      binding.pry
    end
    assert_response 403
  end
end
