require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :email => "fred@flintstone.com",
              :password => "abc123"
            }
  end

  it "should be successful" do
    User.create!(@attr)
  end

end
