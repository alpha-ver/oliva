require 'test_helper'

class Admin::PostingsControllerTest < ActionController::TestCase
  setup do
    @admin_posting = admin_postings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_postings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_posting" do
    assert_difference('Admin::Posting.count') do
      post :create, admin_posting: { active: @admin_posting.active, allow_mail: @admin_posting.allow_mail, count: @admin_posting.count, description: @admin_posting.description, images: @admin_posting.images, manager: @admin_posting.manager, next_at: @admin_posting.next_at, p: @admin_posting.p, price: @admin_posting.price, title: @admin_posting.title, user_id: @admin_posting.user_id }
    end

    assert_redirected_to admin_posting_path(assigns(:admin_posting))
  end

  test "should show admin_posting" do
    get :show, id: @admin_posting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_posting
    assert_response :success
  end

  test "should update admin_posting" do
    patch :update, id: @admin_posting, admin_posting: { active: @admin_posting.active, allow_mail: @admin_posting.allow_mail, count: @admin_posting.count, description: @admin_posting.description, images: @admin_posting.images, manager: @admin_posting.manager, next_at: @admin_posting.next_at, p: @admin_posting.p, price: @admin_posting.price, title: @admin_posting.title, user_id: @admin_posting.user_id }
    assert_redirected_to admin_posting_path(assigns(:admin_posting))
  end

  test "should destroy admin_posting" do
    assert_difference('Admin::Posting.count', -1) do
      delete :destroy, id: @admin_posting
    end

    assert_redirected_to admin_postings_path
  end
end
