require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :email => "fred@flintstone.com",
              :password => "abc123"
            }
  end

  it "should create user" do
    User.create!(@attr)
  end

  it "should not create duplicate user" do
    User.create!(@attr)
    dup_user = User.new(@attr)
    dup_user.should_not be_valid
  end

  it "should not create duplicate email" do
    User.create!(@attr)
    dup_email = User.new(@attr.merge(:email => "fred@flintstone.com"))
    dup_email.should_not be_valid
  end

  it "email should not be blank" do
    user_email = User.new(@attr.merge(:email => ""))
    user_email.should_not be_valid
  end

  it "should accept valid emails" do
    emails = %w[user@foo.com The_User@foo.bar.org first.last@foo.jp]
    emails.each do |em|
      valid_email_user = User.new(@attr.merge(:email => em))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    emails = %w[user@foo,com User_at_foo.org first.last@foo.]
    emails.each do |em|
      invalid_email_user = User.new(@attr.merge(:email => em))
      invalid_email_user.should_not be_valid
    end
  end

end
