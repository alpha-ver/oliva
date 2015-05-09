require 'test_helper'

class Vk::AccountsControllerTest < ActionController::TestCase
  setup do
    @vk_account = vk_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vk_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vk_account" do
    assert_difference('Vk::Account.count') do
      post :create, vk_account: { active: @vk_account.active, info: @vk_account.info, login: @vk_account.login, pass: @vk_account.pass, phone: @vk_account.phone, proxy_id: @vk_account.proxy_id, status: @vk_account.status, user_id: @vk_account.user_id }
    end

    assert_redirected_to vk_account_path(assigns(:vk_account))
  end

  test "should show vk_account" do
    get :show, id: @vk_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vk_account
    assert_response :success
  end

  test "should update vk_account" do
    patch :update, id: @vk_account, vk_account: { active: @vk_account.active, info: @vk_account.info, login: @vk_account.login, pass: @vk_account.pass, phone: @vk_account.phone, proxy_id: @vk_account.proxy_id, status: @vk_account.status, user_id: @vk_account.user_id }
    assert_redirected_to vk_account_path(assigns(:vk_account))
  end

  test "should destroy vk_account" do
    assert_difference('Vk::Account.count', -1) do
      delete :destroy, id: @vk_account
    end

    assert_redirected_to vk_accounts_path
  end
end
