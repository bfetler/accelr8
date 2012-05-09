require 'spec_helper'

describe AcceleratorUser do

  before(:each) do
    @attr = { :name => "Flintstone Accelerator",
              :email => "fred@accelerator.com",
              :password => "mypass"
            }
  end

  it "should create accelerator user" do
    AcceleratorUser.create!(@attr)
  end

  it "should not create duplicate accelerator user" do
    AcceleratorUser.create!(@attr)
    dup_user = AcceleratorUser.new(@attr)
    dup_user.should_not be_valid
  end

  it "name should not be blank" do
    user_name = AcceleratorUser.new(@attr.merge(:name => ""))
    user_name.should_not be_valid
  end

  it "should not create duplicate email" do
    AcceleratorUser.create!(@attr)
    dup_email = AcceleratorUser.new(@attr.merge(:email => "fred@flintstone.com"))
    dup_email.should_not be_valid
  end

  it "email should not be blank" do
    user_email = AcceleratorUser.new(@attr.merge(:email => ""))
    user_email.should_not be_valid
  end

  it "should accept valid emails" do
    emails = %w[user@foo.com The_User@foo.bar.org first.last@foo.jp]
    emails.each do |em|
      valid_email_user = AcceleratorUser.new(@attr.merge(:email => em))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    emails = %w[user@foo,com User_at_foo.org first.last@foo.]
    emails.each do |em|
      invalid_email_user = AcceleratorUser.new(@attr.merge(:email => em))
      invalid_email_user.should_not be_valid
    end
  end

end
