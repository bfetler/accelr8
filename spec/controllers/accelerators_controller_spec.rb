require 'spec_helper'

describe AcceleratorsController do

  before(:each) do
    @attr = { :email => "fred.flintstone.com",
              :password => "abc123"
            }
  end

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
