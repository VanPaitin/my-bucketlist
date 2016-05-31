require "test_helper"

class ShowABucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user2 = create(:user)
    @bucketlist = create(:bucketlist, user_id: @user.id)
    @bucketlist2 = create(:bucketlist, user_id: @user2.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json",
                 "Authorization" => token }
  end

  test "only logged in user can assess the bucketlist resource" do
    get "/api/v1/bucketlists/#{@bucketlist.id}"

    assert_response 401
    assert_equal language.not_authenticated, json(response.body)[:error]
  end

  test "a user can only show his bucketlist" do
    get "/api/v1/bucketlists/#{@bucketlist.id}", {}, @headers
    bucket_list_response = json(response.body)

    assert_equal 200, response.status
    assert_equal @bucketlist.name, bucket_list_response[:name]
  end

  test "a user will not see a bucketlist that does not belong to him" do
    get "/api/v1/bucketlists/#{@bucketlist2.id}", {}, @headers

    assert @bucketlist2.present?
    assert_equal 404, response.status
  end
end
