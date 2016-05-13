require "test_helper"

class CreateBucketlistTest < ActionDispatch::IntegrationTest
  setup { @user = create(:user) }
  test "success when name is of normal length" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      post "/api/v1/bucketlists", { bucketlist: { name: "Test bucketlist" } }.
        to_json, "Content-Type" => "application/json"
    end
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    assert_equal JSON.parse(response.body, symbolize_names: true)[:name],
                 "Test bucketlist"
  end
  test "failure when name is too short" do
    assert_no_difference "@user.bucketlists.count" do
      ApplicationController.stub_any_instance(:current_user, @user) do
        post "/api/v1/bucketlists", { bucketlist: { name: "T" } }.
          to_json, "Content-Type" => "application/json"
      end
    end
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 2 characters)"
  end
end
