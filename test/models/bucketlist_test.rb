require "test_helper"

class BucketlistTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @bucketlist = @user.bucketlists.create(name: "bukola")
    @bucketlist2 = @user.bucketlists.create(name: "firstLIST")
    3.times { @user.bucketlists.create(name: "fakerLisT#{rand(100)}") }
  end
  should belong_to(:user)
  should have_many(:items).dependent(:destroy)
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_least(2).is_at_most(40)
  should validate_uniqueness_of(:name).case_insensitive

  test "can return the result of a given search term" do
    assert_equal 5, @user.bucketlists.count
    assert_equal 4, Bucketlist.search(@user, "list").count
    refute_includes Bucketlist.search(@user, "list").
      map(&:name), @bucketlist.name
    assert_includes Bucketlist.search(@user, "list").
      map(&:name), @bucketlist2.name
  end
end
