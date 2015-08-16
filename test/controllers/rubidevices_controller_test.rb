require 'test_helper'

class RubidevicesControllerTest < ActionController::TestCase
  setup do
    @rubidevice = rubidevices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rubidevices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rubidevice" do
    assert_difference('Rubidevice.count') do
      post :create, rubidevice: { creation: @rubidevice.creation, identifier: @rubidevice.identifier, model: @rubidevice.model, owner: @rubidevice.owner, user_id: @rubidevice.user_id }
    end

    assert_redirected_to rubidevice_path(assigns(:rubidevice))
  end

  test "should show rubidevice" do
    get :show, id: @rubidevice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rubidevice
    assert_response :success
  end

  test "should update rubidevice" do
    patch :update, id: @rubidevice, rubidevice: { creation: @rubidevice.creation, identifier: @rubidevice.identifier, model: @rubidevice.model, owner: @rubidevice.owner, user_id: @rubidevice.user_id }
    assert_redirected_to rubidevice_path(assigns(:rubidevice))
  end

  test "should destroy rubidevice" do
    assert_difference('Rubidevice.count', -1) do
      delete :destroy, id: @rubidevice
    end

    assert_redirected_to rubidevices_path
  end
end
