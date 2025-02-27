require "application_system_test_case"

class CartProductsTest < ApplicationSystemTestCase
  setup do
    @cart_product = cart_products(:one)
  end

  test "visiting the index" do
    visit cart_products_url
    assert_selector "h1", text: "Cart products"
  end

  test "should create cart product" do
    visit cart_products_url
    click_on "New cart product"

    fill_in "Cart", with: @cart_product.cart_id
    fill_in "Product", with: @cart_product.product_id
    fill_in "Quantity", with: @cart_product.quantity
    click_on "Create Cart product"

    assert_text "Cart product was successfully created"
    click_on "Back"
  end

  test "should update Cart product" do
    visit cart_product_url(@cart_product)
    click_on "Edit this cart product", match: :first

    fill_in "Cart", with: @cart_product.cart_id
    fill_in "Product", with: @cart_product.product_id
    fill_in "Quantity", with: @cart_product.quantity
    click_on "Update Cart product"

    assert_text "Cart product was successfully updated"
    click_on "Back"
  end

  test "should destroy Cart product" do
    visit cart_product_url(@cart_product)
    click_on "Destroy this cart product", match: :first

    assert_text "Cart product was successfully destroyed"
  end
end
