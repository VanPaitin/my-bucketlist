require "test_helper"

class UserRoutesTest < ActionDispatch::IntegrationTest
  test "the routes" do
    assert_generates "/api/users/1",
                     controller: "api/users", action: "show", id: 1
  end

  test "should route to create a user" do
    assert_routing({ method: "post", path: "/api/users" },
                   controller: "api/users", action: "create")
  end

  test "should route to update a user" do
    assert_routing({ method: "put", path: "/api/users/2" },
                   controller: "api/users", action: "update", id: "2")
  end

  test "should route to delete a user" do
    assert_routing({ method: "delete", path: "/api/users/3" },
                   controller: "api/users", action: "destroy", id: "3")
  end
end
