require 'test_helper'

class RubisControllerTest < ActionController::TestCase
  setup do
    @rubi = rubis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rubis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rubi" do
    assert_difference('Rubi.count') do
      post :create, rubi: { nombre: @rubi.nombre, serie: @rubi.serie, user_id: @rubi.user_id }
    end

    assert_redirected_to rubi_path(assigns(:rubi))
  end

  test "should show rubi" do
    get :show, id: @rubi
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rubi
    assert_response :success
  end

  test "should update rubi" do
    patch :update, id: @rubi, rubi: { nombre: @rubi.nombre, serie: @rubi.serie, user_id: @rubi.user_id }
    assert_redirected_to rubi_path(assigns(:rubi))
  end

  test "should destroy rubi" do
    assert_difference('Rubi.count', -1) do
      delete :destroy, id: @rubi
    end

    assert_redirected_to rubis_path
  end
end
