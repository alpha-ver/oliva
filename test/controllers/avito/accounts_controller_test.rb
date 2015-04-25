require 'test_helper'

class Avito::AccountsControllerTest < ActionController::TestCase
  setup do
    @avito_account = avito_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:avito_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create avito_account" do
    assert_difference('Avito::Account.count') do
      post :create, avito_account: { f: @avito_account.f, login: @avito_account.login, pass: @avito_account.pass, status: @avito_account.status, user_id: @avito_account.user_id }
    end

    assert_redirected_to avito_account_path(assigns(:avito_account))
  end

  test "should show avito_account" do
    get :show, id: @avito_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @avito_account
    assert_response :success
  end

  test "should update avito_account" do
    patch :update, id: @avito_account, avito_account: { f: @avito_account.f, login: @avito_account.login, pass: @avito_account.pass, status: @avito_account.status, user_id: @avito_account.user_id }
    assert_redirected_to avito_account_path(assigns(:avito_account))
  end

  test "should destroy avito_account" do
    assert_difference('Avito::Account.count', -1) do
      delete :destroy, id: @avito_account
    end

    assert_redirected_to avito_accounts_path
  end
end
