require 'spec_helper'

describe AcceleratorsController do

  before { sign_in FactoryGirl.create(:user) }

# @request.env["devise.mapping"] = Devise.mappings[:accelerator_user]
  let(:accelerator_user) { FactoryGirl.create(:accelerator_user) }

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

    describe "POST 'terms'" do
      it "should be successful" do
        post 'terms'
        response.should be_success
      end
    end

#   describe "GET 'show'" do
#     it "should be successful" do
#       get 'show', :accelerator_user => accelerator_user
#       response.should be_success
#     end
#   end

  end  # With Accelerator User

end
