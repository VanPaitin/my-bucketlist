require "test_helper"

class ListBucketlistsTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    create_list(:bucketlist, 104, user_id: @user.id)
    token = token(@user)
    @headers = { "Content-Type" => "application/json",
                 "Authorization" => token }
  end

  test "returns a default number of 20 records" do
    assert_equal 104, @user.bucketlists.count
    get "/api/v1/bucketlists", {}, @headers
    assert_equal 200, response.status
    refute_empty response.body
    bucketlists = json(response.body)
    assert_equal 20, bucketlists[:bucketlist].count
  end

  test "returns the number of records specified" do
    get "/api/v1/bucketlists?limit=34", {}, @headers
    assert_equal 200, response.status
    bucketlists = json(response.body)
    assert_equal 34, bucketlists[:bucketlist].count
  end

  test "cannot return more than 100 bucketlists at a time" do
    assert_equal 104, @user.bucketlists.count
    get "/api/v1/bucketlists?limit=103", {}, @headers
    assert_equal 200, response.status
    bucketlists = json(response.body)
    refute_equal @user.bucketlists.count, bucketlists[:bucketlist].count
    assert_equal 100, bucketlists[:bucketlist].count
  end

  test "returns 20 records (default) that are in a particular page" do
    get "/api/v1/bucketlists?page=3", {}, @headers
    assert_equal 200, response.status
    bucketlists = json(response.body)
    assert_equal 20, bucketlists[:bucketlist].count
    assert_equal 41, bucketlists[:bucketlist].first[:id]
    assert_equal 60, bucketlists[:bucketlist].last[:id]
    assert_equal 6, bucketlists[:info_summary][:total_pages]
    assert_equal 3, bucketlists[:info_summary][:current_page]
  end

  test "returns number of records specified on a given page" do
    get "/api/v1/bucketlists?page=3&limit=12", {}, @headers
    assert_equal 200, response.status
    bucketlists = json(response.body)
    assert_equal 12, bucketlists[:bucketlist].count
    assert_equal 25, bucketlists[:bucketlist].first[:id]
    assert_equal 36, bucketlists[:bucketlist].last[:id]
    assert_equal 9, bucketlists[:info_summary][:total_pages]
  end
end
