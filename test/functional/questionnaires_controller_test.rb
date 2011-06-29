require 'test_helper'

class QuestionnairesControllerTest < ActionController::TestCase
  setup do
    @questionnaire = questionnaires(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:questionnaires)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create questionnaire" do
    assert_difference('Questionnaire.count') do
      post :create, :questionnaire => @questionnaire.attributes
    end

    assert_redirected_to questionnaire_path(assigns(:questionnaire))
  end

  test "should show questionnaire" do
    get :show, :id => @questionnaire.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @questionnaire.to_param
    assert_response :success
  end

  test "should update questionnaire" do
    put :update, :id => @questionnaire.to_param, :questionnaire => @questionnaire.attributes
    assert_redirected_to questionnaire_path(assigns(:questionnaire))
  end

  test "should destroy questionnaire" do
    assert_difference('Questionnaire.count', -1) do
      delete :destroy, :id => @questionnaire.to_param
    end

    assert_redirected_to questionnaires_path
  end
end
