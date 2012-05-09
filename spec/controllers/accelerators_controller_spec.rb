require 'spec_helper'

describe AcceleratorsController do

# before(:each) do
#   @user = { :email => "fred@flintstone.com",
#             :password => "abc123"
#           }
#   sign_in @user
# end

  let(:user) { FactoryGirl.create(:user) }
# let(:accelerator_user) { FactoryGirl.create(:accelerator_user) }

  before { sign_in user }
  before {
#     @request.env["devise.mapping"] = Devise.mappings[:accelerator_user]
      sign_in FactoryGirl.create(:accelerator_user)
  }

  describe "User Sign In" do
    it "should have a current user" do
      subject.current_user.should_not be_nil
    end
  end

  describe "Accelerator User Sign In" do
    it "should have a current accelerator user" do
      subject.current_accelerator_user.should_not be_nil
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST 'terms'" do
    it "should be successful" do
      post 'terms'
      response.should be_success
    end
  end

end
