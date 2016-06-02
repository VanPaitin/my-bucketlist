require "test_helper"

class CreateBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = build(:bucketlist)
    token = token(@user)
    @headers = { "Content-Type" => "application/json",
                 "Authorization" => token }
  end

  test "user cannot create a bucketlist without a valid token" do
    post "/api/v1/bucketlists", { name: @bucketlist.name }.to_json

    assert_response 401
    assert_equal language.not_authenticated, json(response.body)[:error]
  end

  test "success when name is of normal length (between 2 to 40 characters)" do
    post "/api/v1/bucketlists", { name: @bucketlist.name }.to_json, @headers

    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    assert_equal json(response.body)[:name], @bucketlist.name
  end

  test "failure when name is too short (less than two characters)" do
    assert_no_difference "@user.bucketlists.count" do
      post "/api/v1/bucketlists", { name: "T" }.to_json, @headers
    end
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
    assert json(response.body)[:errors][:name].present?
  end

  test "should fail if parameters are not right" do
    assert_no_difference "@user.bucketlists.count" do
      post "/api/v1/bucketlists", {}, @headers
    end
    assert_response 422
    assert json(response.body)[:errors].present?
  end
end
