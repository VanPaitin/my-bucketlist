require "test_helper"

class CreateBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = build(:bucketlist)
  end
  test "success when name is of normal length" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      post "/api/v1/bucketlists", { name: @bucketlist.name }.to_json,
           "Content-Type" => "application/json"
    end
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    assert_equal json(response.body)[:name], @bucketlist.name
  end

  test "failure when name is too short" do
    assert_no_difference "@user.bucketlists.count" do
      ApplicationController.stub_any_instance(:current_user, @user) do
        post "/api/v1/bucketlists", { name: "T" }.to_json,
             "Content-Type" => "application/json"
      end
    end
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 2 characters)"
  end

  test "should fail if parameters are not right" do
    assert_no_difference "@user.bucketlists.count" do
      ApplicationController.stub_any_instance(:current_user, @user) do
        post "/api/v1/bucketlists"
      end
    end
    assert_response 422
  end
end
