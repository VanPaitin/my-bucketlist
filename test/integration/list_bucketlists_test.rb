require 'test_helper'

class ListBucketlistsTest < ActionDispatch::IntegrationTest

  test "returns the lists of all the bucket lists" do
    bucket1 = create(:bucketlist)
    bucket2 = create(:bucketlist, name: "Second bucket")
    get "/api/vi/bucketlists"
    assert_equal 200, response.status
    refute_empty response.body
    bucketlists = json(response.body)
    names = bucketlists.collect { |z| z[:name] }
    assert_includes names, "Second bucket"
    refute_includes names, "Third one"
  end
end
