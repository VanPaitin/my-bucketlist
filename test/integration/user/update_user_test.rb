require 'test_helper'

class UpdateUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @new_name = user.name
    @user2 = create(:user)
  end
  test "can update user with the right credentials" do
    refute_equal @new_name, @user.name
    ApplicationController.stub_any_instance(:current_user, @user) do
      put "/api/users/#{@user.id}", { user: { name: @new_name, email: user.email,
                                   password: user.password,
                                   password_confirmation: user.
                                     password_confirmation } }.to_json,
           "Content-Type" => "application/json"
    end
    assert_equal @new_name, @user.reload.name
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
  end
  test "cannot update user with invalid credentials" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      put "/api/users/#{@user.id}", { user: { name: "", email: user.email,
                                   password: user.password,
                                   password_confirmation: user.
                                     password_confirmation } }.to_json,
           "Content-Type" => "application/json"
    end
    assert_equal 422, response.status
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 6 characters)"
  end
  test "cannot update another user" do
    ApplicationController.stub_any_instance(:current_user, @user2) do
      put "/api/users/#{@user.id}", { user: { name: @user2.name, email: user.email,
                                   password: user.password,
                                   password_confirmation: user.
                                     password_confirmation } }.to_json,
           "Content-Type" => "application/json"
    end
    assert_equal 403, response.status
  end
end
