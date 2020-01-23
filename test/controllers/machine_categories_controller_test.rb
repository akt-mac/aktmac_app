require 'test_helper'

class MachineCategoryControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get machine_categories_new_url
    assert_response :success
  end

  test "should get index" do
    get machine_categories_index_url
    assert_response :success
  end

  test "should get create" do
    get machine_categories_create_url
    assert_response :success
  end

  test "should get update" do
    get machine_categories_update_url
    assert_response :success
  end

  test "should get destroy" do
    get machine_categories_destroy_url
    assert_response :success
  end

end
