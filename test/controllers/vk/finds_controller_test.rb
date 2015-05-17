require 'test_helper'

class Vk::FindsControllerTest < ActionController::TestCase
  setup do
    @vk_find = vk_finds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vk_finds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vk_find" do
    assert_difference('Vk::Find.count') do
      post :create, vk_find: { active: @vk_find.active, count: @vk_find.count, error_code: @vk_find.error_code, find_count: @vk_find.find_count, find_ids: @vk_find.find_ids, interval: @vk_find.interval, map_find: @vk_find.map_find, name: @vk_find.name, next_at: @vk_find.next_at, p: @vk_find.p, step_count: @vk_find.step_count, user_id: @vk_find.user_id }
    end

    assert_redirected_to vk_find_path(assigns(:vk_find))
  end

  test "should show vk_find" do
    get :show, id: @vk_find
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vk_find
    assert_response :success
  end

  test "should update vk_find" do
    patch :update, id: @vk_find, vk_find: { active: @vk_find.active, count: @vk_find.count, error_code: @vk_find.error_code, find_count: @vk_find.find_count, find_ids: @vk_find.find_ids, interval: @vk_find.interval, map_find: @vk_find.map_find, name: @vk_find.name, next_at: @vk_find.next_at, p: @vk_find.p, step_count: @vk_find.step_count, user_id: @vk_find.user_id }
    assert_redirected_to vk_find_path(assigns(:vk_find))
  end

  test "should destroy vk_find" do
    assert_difference('Vk::Find.count', -1) do
      delete :destroy, id: @vk_find
    end

    assert_redirected_to vk_finds_path
  end
end
