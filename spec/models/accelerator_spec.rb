require 'spec_helper'

describe Accelerator do

  before(:each) do
    @attr = { :name => "testaccel",
              :city => "San Francisco",
              :state => "CA",
              :startdate => "2012-02-19",
              :duedate => "2012-02-12",
              :length => "8",
              :website => "http://www.google.com",
              :lastname => "Flintstone",
              :email => "fred@flintstone.com",
              :description => "Flinstone accelerator.",
              :acceptlate => "no"
            }
  end

  it "should be successful" do
    Accelerator.create!(@attr)
  end

end
