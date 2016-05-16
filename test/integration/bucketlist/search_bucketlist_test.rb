require "test_helper"

class Bucketlist::SearchBucketlistTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @bucketlist = @user.bucketlists.create(name: "bukola")
    @bucketlist2 = @user.bucketlists.create(name: "firstLIST")
    3.times { @user.bucketlists.create(name: "fakerLisT#{rand(100)}") }
  end

  test "returns bucketlists that match search params (case-insensitively)" do
    assert_equal 5, @user.bucketlists.count
    ApplicationController.stub_any_instance(:current_user, @user) do
      get "/api/v1/bucketlists", q: "list"
    end
    assert_response 200
    bucketlists = json(response.body)
    assert_equal 4, bucketlists[:bucketlist].count
    assert_equal "firstLIST", bucketlists[:bucketlist].first[:name]
    refute_includes bucketlists[:bucketlist].map { |list| list[:name] },
                    @bucketlist.name
    assert_includes bucketlists[:bucketlist].map { |list| list[:name] },
                    @bucketlist2.name
  end

  test "returns empty if nothing matches search params" do
    ApplicationController.stub_any_instance(:current_user, @user) do
      get "/api/v1/bucketlists", q: "andela"
    end
    assert_response 404
    bucketlists = json(response.body)
    assert_equal "No records found", bucketlists[:message]
  end

end
