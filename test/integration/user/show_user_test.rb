require 'test_helper'

class User::ShowUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
  end
  test "the truth" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      get "/api/users/#{@user.id}"
    end
    assert_equal 200, response.status
    user_response = json(response.body)
    assert_equal @user.name, user_response[:name]
    assert_equal @user.email, user_response[:email]
  end
  test "cannot see another user's page" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      get "/api/users/#{@user2.id}"
    end
    assert_equal 403, response.status
  end
end
