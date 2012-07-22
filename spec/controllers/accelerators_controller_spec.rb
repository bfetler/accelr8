require 'spec_helper'

describe AcceleratorsController do

  before { sign_in FactoryGirl.create(:user) }

# @request.env["devise.mapping"] = Devise.mappings[:accelerator_user]
  let(:accelerator_user) { FactoryGirl.create(:accelerator_user) }
  let(:accelerator) { FactoryGirl.create(:accelerator, :accelerator_user => accelerator_user) }

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

  describe "With Accelerator User" do
    before { sign_in accelerator_user }

    describe "Accelerator User Sign In" do
      it "should have a current accelerator user" do
        subject.current_accelerator_user.should_not be_nil
      end
    end

    describe "GET 'new'" do
      it "should be successful" do
        get 'new'
        response.should render_template('new')
      end

#     it "should have correct title div" do   # needs render_views
#       get 'new'
#       response.should have_selector("div", :class => "span-6 bigfont bigmargin last", :content => "Create New Accelerator")
#     end
    end

    describe "GET 'home'" do
      it "should not be successful if a user is logged in" do
        get 'home'
        response.should_not be_success
      end
    end

    describe "POST 'terms'" do
      it "should be successful" do
        post 'terms'
        response.should render_template('terms')
      end
    end

    describe "GET 'show'" do
      it "should be successful" do
        get 'show', :id => accelerator
        response.should render_template('show')
      end

      it "should find correct accelerator" do
        get 'show', :id => accelerator
        assigns(:accelerator).should == accelerator
      end
    end

    describe "GET 'edit'" do
      it "should be successful" do
        get 'edit', :id => accelerator
        response.should render_template('edit')
      end
    end

#   describe "PUT 'update'" do
#     it "should be successful" do
#       put 'update', :id => accelerator
#       response.should render_template('index')
#     end
#   end

#   describe "DELETE 'destroy'" do
#     it "should be successful" do
#       delete 'destroy', :id => accelerator
#       response.should render_template('index')
#     end
#   end

  end  # With Accelerator User

end
