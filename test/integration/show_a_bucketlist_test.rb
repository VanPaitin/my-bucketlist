require 'test_helper'

class ShowABucketlistTest < ActionDispatch::IntegrationTest
  test "can show a bucketlist" do
    bucket_list = Bucketlist.create!(name: "Test bucketlist")
    get "/api/v1/bucketlists/#{bucket_list.id}"
    assert_equal 200, response.status
    bucket_list_response = json(response.body)
    assert_equal bucket_list.name, bucket_list_response[:name]
  end
end
