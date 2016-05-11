require "test_helper"

class DeleteBucketlistTest < ActionDispatch::IntegrationTest
  setup { @bucketlist = create(:bucketlist) }
  test "can delete a bucketlist" do
    assert_equal 1, Bucketlist.count
    assert_difference "Bucketlist.count", -1 do
      delete "/api/v1/bucketlists/#{@bucketlist.id}"
    end
    assert_equal 204, response.status
  end
end
