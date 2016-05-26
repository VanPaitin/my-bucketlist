require "test_helper"

class PaginationTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    create_list(:bucketlist, 10, user_id: @user.id)
    @bucketlists = @user.bucketlists
  end

  test "can set the page and limit of a query" do
    params = { page: 2, limit: 5 }
    pagination = Pagination.new(params, @bucketlists)
    assert_equal 2, pagination.page
    assert_equal 5, pagination.limit
  end

  test "will default limit to 20 records if no limit is passed" do
    params = { page: 3 }
    pagination = Pagination.new(params, @bucketlists)
    assert_equal 20, pagination.limit
    assert_equal 3, pagination.page
  end

  test "will set limit to 100 records if limit is more than 100" do
    params = { limit: 105 }
    pagination = Pagination.new(params, @bucketlists)
    assert_equal 100, pagination.limit
  end

  test "can paginate based on page and limit specified" do
    params = { page: 2, limit: 5 }
    pagination = Pagination.new(params, @bucketlists)
    assert_equal params[:limit], pagination.paginate[:bucketlist].object.count
    assert_equal 6, pagination.paginate[:bucketlist].object.first.id
  end
end
