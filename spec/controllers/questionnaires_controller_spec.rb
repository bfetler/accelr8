require 'spec_helper'

# controller specs similar to Hartl - use Factory models, render_template

describe QuestionnairesController do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

# @request.env["devise.mapping"] = Devise.mappings[:user]
  let(:questionnaire) { FactoryGirl.build(:questionnaire, :user => user) }

  describe "User Sign In" do
    it "should have a current user" do
      subject.current_user.should_not be_nil
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "With Saved Questionnaire" do
    before do
      questionnaire.qfounders << Factory.build(:qfounder, :questionnaire => questionnaire)
      questionnaire.save!
    end

    describe "GET 'new'" do
      it "should be successful" do
        get 'new'
        response.should render_template('new')
      end
    end

    describe "GET 'show'" do
      it "should be successful" do
        get 'show', :id => questionnaire
        response.should render_template('show')
      end

      it "should find correct questionnaire" do
        get 'show', :id => questionnaire
        assigns(:questionnaire).should == questionnaire
      end
    end

    describe "GET 'edit'" do
      it "should be successful" do
        get 'edit', :id => questionnaire
        response.should render_template('edit')
      end
    end

    describe "PUT 'update'" do
      it "should be successful" do
        lambda do
          put 'update', :id => questionnaire
#         response.should render_template('show')  # render is a view spec
        end.should_not change(Questionnaire, :count)
      end
    end

    describe "DELETE 'destroy'" do  # :action isn't correct?
      it "should be successful" do
        lambda do
          delete 'destroy', :id => questionnaire
#         response.should render_template(:controller => 'accelerators', :action => 'index')
        end.should change(Questionnaire, :count).by(-1)
      end
    end

  end  # With Saved Questionnaire

end
