require 'test_helper'

class Parse::DbsControllerTest < ActionController::TestCase
  setup do
    @parse_db = parse_dbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parse_dbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parse_db" do
    assert_difference('Parse::Db.count') do
      post :create, parse_db: { additional: @parse_db.additional, body: @parse_db.body, date: @parse_db.date, img: @parse_db.img, task_id: @parse_db.task_id, title: @parse_db.title, url: @parse_db.url }
    end

    assert_redirected_to parse_db_path(assigns(:parse_db))
  end

  test "should show parse_db" do
    get :show, id: @parse_db
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parse_db
    assert_response :success
  end

  test "should update parse_db" do
    patch :update, id: @parse_db, parse_db: { additional: @parse_db.additional, body: @parse_db.body, date: @parse_db.date, img: @parse_db.img, task_id: @parse_db.task_id, title: @parse_db.title, url: @parse_db.url }
    assert_redirected_to parse_db_path(assigns(:parse_db))
  end

  test "should destroy parse_db" do
    assert_difference('Parse::Db.count', -1) do
      delete :destroy, id: @parse_db
    end

    assert_redirected_to parse_dbs_path
  end
end
