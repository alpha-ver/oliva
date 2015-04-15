require 'test_helper'

class Avito::PostingsControllerTest < ActionController::TestCase
  setup do
    @avito_posting = avito_postings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:avito_postings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create avito_posting" do
    assert_difference('Avito::Posting.count') do
      post :create, avito_posting: { active: @avito_posting.active, allow_mail: @avito_posting.allow_mail, count: @avito_posting.count, description: @avito_posting.description, images: @avito_posting.images, manager: @avito_posting.manager, next_at: @avito_posting.next_at, p: @avito_posting.p, price: @avito_posting.price, title: @avito_posting.title, user_id: @avito_posting.user_id }
    end

    assert_redirected_to avito_posting_path(assigns(:avito_posting))
  end

  test "should show avito_posting" do
    get :show, id: @avito_posting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @avito_posting
    assert_response :success
  end

  test "should update avito_posting" do
    patch :update, id: @avito_posting, avito_posting: { active: @avito_posting.active, allow_mail: @avito_posting.allow_mail, count: @avito_posting.count, description: @avito_posting.description, images: @avito_posting.images, manager: @avito_posting.manager, next_at: @avito_posting.next_at, p: @avito_posting.p, price: @avito_posting.price, title: @avito_posting.title, user_id: @avito_posting.user_id }
    assert_redirected_to avito_posting_path(assigns(:avito_posting))
  end

  test "should destroy avito_posting" do
    assert_difference('Avito::Posting.count', -1) do
      delete :destroy, id: @avito_posting
    end

    assert_redirected_to avito_postings_path
  end
end
