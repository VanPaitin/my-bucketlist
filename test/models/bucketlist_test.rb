require "test_helper"

class BucketlistTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @bucketlist = create(:bucketlist, name: "bukola", user_id: @user.id)
    @bucketlists = create_list(:bucketlist, 3, user_id: @user.id)
  end

  should belong_to(:user)
  should have_many(:items).dependent(:destroy)
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_least(2).is_at_most(40)
  should validate_uniqueness_of(:name).case_insensitive

  test "can return the result of a given search term" do
    search_result = Bucketlist.search(@user, "list")

    assert_equal 4, @user.bucketlists.count
    assert_equal 3, search_result.count
    refute_includes search_result.map(&:name), @bucketlist.name
    assert_equal search_result.count, @bucketlists.count
    assert @bucketlists.all? { |bucketlist| search_result.include? bucketlist }
  end
end
