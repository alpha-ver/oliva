require 'test_helper'

class Vk::InvitesControllerTest < ActionController::TestCase
  setup do
    @vk_invite = vk_invites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vk_invites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vk_invite" do
    assert_difference('Vk::Invite.count') do
      post :create, vk_invite: { active: @vk_invite.active, e: @vk_invite.e, find_ids: @vk_invite.find_ids, interval: @vk_invite.interval, invite_ids: @vk_invite.invite_ids, invited_ids: @vk_invite.invited_ids, name: @vk_invite.name, next_at: @vk_invite.next_at, vk_vkontakte_id: @vk_invite.vk_vkontakte_id }
    end

    assert_redirected_to vk_invite_path(assigns(:vk_invite))
  end

  test "should show vk_invite" do
    get :show, id: @vk_invite
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vk_invite
    assert_response :success
  end

  test "should update vk_invite" do
    patch :update, id: @vk_invite, vk_invite: { active: @vk_invite.active, e: @vk_invite.e, find_ids: @vk_invite.find_ids, interval: @vk_invite.interval, invite_ids: @vk_invite.invite_ids, invited_ids: @vk_invite.invited_ids, name: @vk_invite.name, next_at: @vk_invite.next_at, vk_vkontakte_id: @vk_invite.vk_vkontakte_id }
    assert_redirected_to vk_invite_path(assigns(:vk_invite))
  end

  test "should destroy vk_invite" do
    assert_difference('Vk::Invite.count', -1) do
      delete :destroy, id: @vk_invite
    end

    assert_redirected_to vk_invites_path
  end
end
