require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
  test "the routes" do
    assert_generates "/api/v1/bucketlists",
                     controller: "api/v1/bucketlists", action: "index"
    assert_generates "/api/v1/bucketlists/1",
                     controller: "api/v1/bucketlists", action: "show", id: 1
  end
  test "should route to create a bucketlist" do
    assert_routing({ method: "post", path: "/api/v1/bucketlists" },
                   controller: "api/v1/bucketlists", action: "create")
  end
end
