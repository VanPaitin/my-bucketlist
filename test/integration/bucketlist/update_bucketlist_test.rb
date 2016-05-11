require "test_helper"

class UpdateBucketlistTest < ActionDispatch::IntegrationTest
  setup { @bucketlist = create(:bucketlist) }
  test "can update a bucketlist" do
    assert_equal "Test bucketlist", @bucketlist.name
    patch "/api/v1/bucketlists/#{@bucketlist.id}",
          { bucketlist: { name: "my bucketlist" } }.to_json,
          "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s
    assert_equal 200, response.status
    assert_equal "my bucketlist", @bucketlist.reload.name
  end
  test "unsuccessful update with invalid name" do
    patch "/api/v1/bucketlists/#{@bucketlist.id}",
          { bucketlist: { name: nil } }.to_json,
          "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s
    assert_equal 422, response.status
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 2 characters)"
  end
end
