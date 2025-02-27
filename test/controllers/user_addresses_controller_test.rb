require "test_helper"

class UserAddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_address = user_addresses(:one)
  end

  test "should get index" do
    get user_addresses_url
    assert_response :success
  end

  test "should get new" do
    get new_user_address_url
    assert_response :success
  end

  test "should create user_address" do
    assert_difference("UserAddress.count") do
      post user_addresses_url, params: { user_address: { address_line1: @user_address.address_line1, address_line2: @user_address.address_line2, city: @user_address.city, country: @user_address.country, postal_code: @user_address.postal_code, state: @user_address.state, user_id: @user_address.user_id } }
    end

    assert_redirected_to user_address_url(UserAddress.last)
  end

  test "should show user_address" do
    get user_address_url(@user_address)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_address_url(@user_address)
    assert_response :success
  end

  test "should update user_address" do
    patch user_address_url(@user_address), params: { user_address: { address_line1: @user_address.address_line1, address_line2: @user_address.address_line2, city: @user_address.city, country: @user_address.country, postal_code: @user_address.postal_code, state: @user_address.state, user_id: @user_address.user_id } }
    assert_redirected_to user_address_url(@user_address)
  end

  test "should destroy user_address" do
    assert_difference("UserAddress.count", -1) do
      delete user_address_url(@user_address)
    end

    assert_redirected_to user_addresses_url
  end
end
