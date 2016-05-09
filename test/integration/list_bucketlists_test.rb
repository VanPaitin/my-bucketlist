require "test_helper"

class ListBucketlistsTest < ActionDispatch::IntegrationTest
  test "returns the lists of all the bucket lists" do
    create(:bucketlist)
    create(:bucketlist, name: "Second bucket")
    get "/api/v1/bucketlists"
    assert_equal 200, response.status
    refute_empty response.body
    bucketlists = json(response.body)
    names = bucketlists.map { |z| z[:name] }
    assert_includes names, "Second bucket"
    refute_includes names, "Third one"
  end
end
