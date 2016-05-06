require 'test_helper'

class CreateUserTest < ActionDispatch::IntegrationTest
  test "success when name is of normal length" do
    post "/api/v1/bucketlists", { bucketlist: {name: "Test bucketlist" }}.
      to_json, "Content-Type" => "application/json"
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    assert_equal JSON.parse(response.body, symbolize_names: true)[:name],
      "Test bucketlist"
  end
  test "failure when name is too short" do
    post "/api/v1/bucketlists", { bucketlist: {name: "" }}.
      to_json, "Content-Type" => "application/json"
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
    assert_includes JSON.parse(response.body, symbolize_names: true)[
      :errors][:name], "is too short (minimum is 2 characters)"
  end
end
