require 'spec_helper'

describe AcceleratorsController do

# do not log in user

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

end
