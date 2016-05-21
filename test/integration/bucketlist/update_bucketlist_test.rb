require "test_helper"

class UpdateBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist)
    @bucketlist.update_attribute(:user_id, @user.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json", "Accept" => Mime::JSON,
                 "Authorization" => token }
  end

  test "can update a bucketlist" do
    patch "/api/v1/bucketlists/#{@bucketlist.id}",
          { name: "my bucketlist" }.to_json, @headers
    assert_equal 200, response.status
    assert_equal "my bucketlist", @bucketlist.reload.name
  end

  test "unsuccessful update with invalid name" do
    patch "/api/v1/bucketlists/#{@bucketlist.id}",
          { name: "c" }.to_json, @headers
    refute_equal "c", @bucketlist.reload.name
    assert_equal @bucketlist.name, @bucketlist.reload.name
    assert_equal 422, response.status
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 2 characters)"
  end
end
