require 'test_helper'

class Vk::AccountGroupsControllerTest < ActionController::TestCase
  setup do
    @vk_account_group = vk_account_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vk_account_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vk_account_group" do
    assert_difference('Vk::AccountGroup.count') do
      post :create, vk_account_group: { actove: @vk_account_group.actove, cross: @vk_account_group.cross, cross_ids: @vk_account_group.cross_ids, find_id: @vk_account_group.find_id, name: @vk_account_group.name, user_id: @vk_account_group.user_id }
    end

    assert_redirected_to vk_account_group_path(assigns(:vk_account_group))
  end

  test "should show vk_account_group" do
    get :show, id: @vk_account_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vk_account_group
    assert_response :success
  end

  test "should update vk_account_group" do
    patch :update, id: @vk_account_group, vk_account_group: { actove: @vk_account_group.actove, cross: @vk_account_group.cross, cross_ids: @vk_account_group.cross_ids, find_id: @vk_account_group.find_id, name: @vk_account_group.name, user_id: @vk_account_group.user_id }
    assert_redirected_to vk_account_group_path(assigns(:vk_account_group))
  end

  test "should destroy vk_account_group" do
    assert_difference('Vk::AccountGroup.count', -1) do
      delete :destroy, id: @vk_account_group
    end

    assert_redirected_to vk_account_groups_path
  end
end
