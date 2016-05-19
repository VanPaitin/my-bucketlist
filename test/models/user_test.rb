require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup { @user = build(:user, email: Faker::Internet.email.upcase) }

  should have_many(:bucketlists).dependent(:destroy)
  should have_secure_password
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_least(6).is_at_most(50)
  should validate_length_of(:email).is_at_most(255)
  should validate_length_of(:password).is_at_least(6)
  test "user is valid" do
    assert @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
