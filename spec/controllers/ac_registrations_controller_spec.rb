require 'spec_helper'

describe AcRegistrationsController do

# before(:each) do
#   @user = { :email => "fred@flintstone.com",
#             :password => "abc123"
#           }
#   sign_in @user
# end

  let(:user) { FactoryGirl.create(:user) }
  let(:questionnaire) { FactoryGirl.create(:questionnaire) }
  let(:accelerators) { 3.times.each.map { FactoryGirl.create(:accelerator) } }

  before { sign_in user }

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST createbatch" do
    describe "with three accelerators" do
      it "should create three registrations" do
# to_param is id
        post :createbatch, 'quid' => questionnaire.to_param, 'bx' => accelerators.map(&:to_param)
        response.should be_success
      end
    end
  end

end
