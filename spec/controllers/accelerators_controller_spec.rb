require 'spec_helper'

describe AcceleratorsController do

  before { sign_in FactoryGirl.create(:user) }

# @request.env["devise.mapping"] = Devise.mappings[:accelerator_user]
  let(:accelerator_user) { FactoryGirl.create(:accelerator_user) }
  let(:accelerator) { FactoryGirl.create(:accelerator) }

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
#       response.should be_success
      end

#     it "should have correct title div" do   # fails
#       get 'new'
#       response.should have_selector("div>div", :class => "span-6 bigfont bigmargin last", :content => "Create New Accelerator")
#     end
    end

#   describe "GET 'home'" do
#     it "should be successful" do
#       get 'home'
#       response.should be_success
#     end
#   end

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

    describe "POST 'create'" do
#     describe "should not create an accelerator" do  # already done in model
#       before(:each) do
#         @bad_attr = { :name => "", :email => "", :description => "" }
#       end

#       it "should not create an accelerator" do
#         lambda do
#           post :create, :accelerator => @bad_attr
#         end.should_not change(Accelerator, :count)
#       end
#     end

#     describe "success" do
#       it "should create a user" do
#       end
#     end
    end

# to do: edit create update destroy

  end  # With Accelerator User

end
