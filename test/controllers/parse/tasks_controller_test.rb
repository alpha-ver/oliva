require 'test_helper'

class Parse::TasksControllerTest < ActionController::TestCase
  setup do
    @parse_task = parse_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parse_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parse_task" do
    assert_difference('Parse::Task.count') do
      post :create, parse_task: { active: @parse_task.active, base_url: @parse_task.base_url, interval: @parse_task.interval, name: @parse_task.name, r_link: @parse_task.r_link, trigger: @parse_task.trigger, user_id: @parse_task.user_id, x_additional: @parse_task.x_additional, x_body: @parse_task.x_body, x_date: @parse_task.x_date, x_img: @parse_task.x_img, x_link: @parse_task.x_link, x_title: @parse_task.x_title }
    end

    assert_redirected_to parse_task_path(assigns(:parse_task))
  end

  test "should show parse_task" do
    get :show, id: @parse_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parse_task
    assert_response :success
  end

  test "should update parse_task" do
    patch :update, id: @parse_task, parse_task: { active: @parse_task.active, base_url: @parse_task.base_url, interval: @parse_task.interval, name: @parse_task.name, r_link: @parse_task.r_link, trigger: @parse_task.trigger, user_id: @parse_task.user_id, x_additional: @parse_task.x_additional, x_body: @parse_task.x_body, x_date: @parse_task.x_date, x_img: @parse_task.x_img, x_link: @parse_task.x_link, x_title: @parse_task.x_title }
    assert_redirected_to parse_task_path(assigns(:parse_task))
  end

  test "should destroy parse_task" do
    assert_difference('Parse::Task.count', -1) do
      delete :destroy, id: @parse_task
    end

    assert_redirected_to parse_tasks_path
  end
end
