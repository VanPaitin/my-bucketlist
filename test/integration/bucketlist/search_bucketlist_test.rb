require "test_helper"

class Bucketlist::SearchBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist, name: "bukola", user_id: @user.id)
    @bucketlists = create_list(:bucketlist, 3, user_id: @user.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json",
                 "Authorization" => token }
    @bucketlist_names = @bucketlists.map(&:name)
  end

  test "user cannot list bucketlists without a valid token" do
    get "/api/v1/bucketlists?q=list"

    assert_response 401
  end

  test "returns bucketlists that match search params (case-insensitively)" do
    get "/api/v1/bucketlists?q=liST", {}, @headers
    bucketlists = json(response.body)

    assert_equal 4, @user.bucketlists.count
    assert_response 200
    assert_equal 3, bucketlists[:bucketlist].count
    result_names = bucketlists[:bucketlist].map { |list| list[:name] }
    refute_includes result_names, @bucketlist.name
    assert @bucketlist_names.all? do |bucketlist|
      result_names.include? bucketlist
    end
  end

  test "returns empty if nothing matches search params" do
    get "/api/v1/bucketlists?q=andela", {}, @headers
    bucketlists = json(response.body)

    assert_response 404
    assert_equal language.not_found("bucketlists"), bucketlists[:message]
  end
end
