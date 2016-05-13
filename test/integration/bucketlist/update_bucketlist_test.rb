require "test_helper"

class UpdateBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist)
    @bucketlist.update_attribute(:user_id, @user.id)
  end

  test "can update a bucketlist" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      patch "/api/v1/bucketlists/#{@bucketlist.id}",
            { bucketlist: { name: "my bucketlist" } }.to_json,
            "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s
    end
    assert_equal 200, response.status
    assert_equal "my bucketlist", @bucketlist.reload.name
  end
  test "unsuccessful update with invalid name" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      patch "/api/v1/bucketlists/#{@bucketlist.id}",
            { bucketlist: { name: "c" } }.to_json,
            "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s
    end
    refute_equal "c", @bucketlist.reload.name
    assert_equal @bucketlist.name, @bucketlist.reload.name
    assert_equal 422, response.status
    assert_includes json(response.body)[
      :errors][:name], "is too short (minimum is 2 characters)"
  end
end
