require 'test_helper'

class DynamicPagesControllerTest < ActionController::TestCase
  setup do
    @dynamic_page = dynamic_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_page" do
    assert_difference('DynamicPage.count') do
      post :create, dynamic_page: {  }
    end

    assert_redirected_to dynamic_page_path(assigns(:dynamic_page))
  end

  test "should show dynamic_page" do
    get :show, id: @dynamic_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dynamic_page
    assert_response :success
  end

  test "should update dynamic_page" do
    patch :update, id: @dynamic_page, dynamic_page: {  }
    assert_redirected_to dynamic_page_path(assigns(:dynamic_page))
  end

  test "should destroy dynamic_page" do
    assert_difference('DynamicPage.count', -1) do
      delete :destroy, id: @dynamic_page
    end

    assert_redirected_to dynamic_pages_path
  end
end
