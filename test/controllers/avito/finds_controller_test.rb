require 'test_helper'

class Avito::FindsControllerTest < ActionController::TestCase
  setup do
    @avito_find = avito_finds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:avito_finds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create avito_find" do
    assert_difference('Avito::Find.count') do
      post :create, avito_find: { require: @avito_find.require, response: @avito_find.response, user_id: @avito_find.user_id }
    end

    assert_redirected_to avito_find_path(assigns(:avito_find))
  end

  test "should show avito_find" do
    get :show, id: @avito_find
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @avito_find
    assert_response :success
  end

  test "should update avito_find" do
    patch :update, id: @avito_find, avito_find: { require: @avito_find.require, response: @avito_find.response, user_id: @avito_find.user_id }
    assert_redirected_to avito_find_path(assigns(:avito_find))
  end

  test "should destroy avito_find" do
    assert_difference('Avito::Find.count', -1) do
      delete :destroy, id: @avito_find
    end

    assert_redirected_to avito_finds_path
  end
end
