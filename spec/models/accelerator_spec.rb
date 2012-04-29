require 'spec_helper'

describe Accelerator do

  before(:each) do
    @attr = { :name => "testaccel",
              :city => "San Francisco",
              :state => "CA",
              :startdate => 7.days.from_now,
              :duedate => 0.days.from_now,
              :length => "8",
              :website => "http://www.google.com",
              :lastname => "Flintstone",
              :email => "fred@flintstone.com",
              :description => "Flinstone accelerator.",
              :acceptlate => "no"
            }
  end

  it "should create accelerator" do
    Accelerator.create!(@attr)
  end

  it "should require a name" do
    noname_accel = Accelerator.new(@attr.merge(:name => ""))
    noname_accel.should_not be_valid
  end

  it "should reject long description" do
    long_desc_accel = Accelerator.new(@attr.merge(:description => "b" * 301))
    long_desc_accel.should_not be_valid
  end

  it "should require a city" do
    noname_accel = Accelerator.new(@attr.merge(:city => ""))
    noname_accel.should_not be_valid
  end

  it "should require a state" do
    noname_accel = Accelerator.new(@attr.merge(:state => ""))
    noname_accel.should_not be_valid
  end

  it "should require a length" do
    noname_accel = Accelerator.new(@attr.merge(:length => ""))
    noname_accel.should_not be_valid
  end

  it "should require a lastname" do
    noname_accel = Accelerator.new(@attr.merge(:lastname => ""))
    noname_accel.should_not be_valid
  end

  it "should accept duedate before startdate" do
    date_accel = Accelerator.new(@attr.merge(
                    :duedate => 0.days.from_now,
                    :startdate => 1.days.from_now
                 ))
    date_accel.should be_valid
  end

  it "should reject duedate after startdate" do
    date_accel = Accelerator.new(@attr.merge(
                    :duedate => 0.days.from_now,
                    :startdate => -1.days.from_now
                 ))
    date_accel.should_not be_valid
  end

  it "should accept duplicate emails" do
#   ok for development, probably not okay for production
    Accelerator.create!(@attr)
    dup_email_accel = Accelerator.new(@attr)
    dup_email_accel.should be_valid
  end

  it "should accept valid emails" do
    emails = %w[user@foo.com The_User@foo.bar.org first.last@foo.jp]
    emails.each do |em|
      valid_email_accel = Accelerator.new(@attr.merge(:email => em))
      valid_email_accel.should be_valid
    end
  end

  it "should reject invalid emails" do
    emails = %w[user@foo,com User_at_foo.org first.last@foo.]
    emails.each do |em|
      invalid_email_accel = Accelerator.new(@attr.merge(:email => em))
      invalid_email_accel.should_not be_valid
    end
  end

end
