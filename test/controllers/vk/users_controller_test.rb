require 'test_helper'

class Vk::UsersControllerTest < ActionController::TestCase
  setup do
    @vk_user = vk_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vk_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vk_user" do
    assert_difference('Vk::User.count') do
      post :create, vk_user: { city_id: @vk_user.city_id, country_id: @vk_user.country_id, first_name: @vk_user.first_name, friend_count: @vk_user.friend_count, friend_ids: @vk_user.friend_ids, last_name: @vk_user.last_name, private_message: @vk_user.private_message, sex: @vk_user.sex, status: @vk_user.status }
    end

    assert_redirected_to vk_user_path(assigns(:vk_user))
  end

  test "should show vk_user" do
    get :show, id: @vk_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vk_user
    assert_response :success
  end

  test "should update vk_user" do
    patch :update, id: @vk_user, vk_user: { city_id: @vk_user.city_id, country_id: @vk_user.country_id, first_name: @vk_user.first_name, friend_count: @vk_user.friend_count, friend_ids: @vk_user.friend_ids, last_name: @vk_user.last_name, private_message: @vk_user.private_message, sex: @vk_user.sex, status: @vk_user.status }
    assert_redirected_to vk_user_path(assigns(:vk_user))
  end

  test "should destroy vk_user" do
    assert_difference('Vk::User.count', -1) do
      delete :destroy, id: @vk_user
    end

    assert_redirected_to vk_users_path
  end
end
