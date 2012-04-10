require 'spec_helper'

describe AcceleratorsController do

# before(:each) do
#   @user = { :email => "fred@flintstone.com",
#             :password => "abc123"
#           }
#   sign_in @user
# end

  let(:user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

# describe "POST 'terms'" do
#   it "should be successful" do
#     post 'terms'
#     response.should be_success
#   end
# end

end
