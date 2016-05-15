require "test_helper"

class ItemRoutesTest < ActionDispatch::IntegrationTest
  test "should route to create an item" do
    assert_routing({ method: "post", path: "/api/v1/bucketlists/1/items" },
                   controller: "api/v1/items", action: "create",
                   bucketlist_id: "1")
  end

  test "should route to update an item" do
    assert_routing({ method: "put", path: "/api/v1/bucketlists/2/items/2" },
                   controller: "api/v1/items", action: "update", id: "2",
                   bucketlist_id: "2")
  end

  test "should route to delete an item" do
    assert_routing({ method: "delete", path: "/api/v1/bucketlists/5/items/3" },
                   controller: "api/v1/items", action: "destroy", id: "3",
                   bucketlist_id: "5")
  end
end
