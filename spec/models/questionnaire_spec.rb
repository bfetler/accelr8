require 'spec_helper'

describe Questionnaire do

  before(:each) do
    @attr = { :firstname    => "Fred",
              :lastname     => "Flintstone",
              :email        => "fred@flintstone.com",
              :companyname  => "Brontosaurus Burgers",
              :website      => "http://www.google.com",
              :webvideo     => "http://www.youtube.com",
              :description  => "We're gonna make burgers.",
              :businessplan => "Burgers for Slate Quarry lunchtime.",
              :team         => "Fred cooked burgers for the Elk Lodge.",
              :competition  => "Rocky's Oyster Bar.",
              :other        => "Fred won chef of the year, 4014 BC.",
              :invest       => "Mr. Slate is in for 100 clams.",
              :advisor      => "Mr. Slate.",
#             :qfounder     => { "0" => { "firstname" => "Fred", 
#				  "lastname" => "Flintstone",
#				  "willcode" => "",
#				  "role"     => "chef",
#				  "weblink"  => "http://www.linkedin.com/fred"
#				} }
            }
	@fdr =  { "firstname" => "Fred", 
		  "lastname" => "Flintstone",
		  "willcode" => "",
		  "role"     => "chef",
		  "weblink"  => "http://www.linkedin.com/fred"
		}
  end

# let(:qfounder1) { FactoryGirl.create(:qfounder) }

  it "should create questionnaire" do
#   Questionnaire.create!(@attr)
    q = Questionnaire.new(@attr)
    q.qfounders.build(@fdr)
    q.save!
  end

  it "should add one questionnaire to db" do
#   lambda do
    expect do
      q = Questionnaire.new(@attr)
      q.qfounders.build(@fdr)
      q.save!
    end.should change(Questionnaire, :count).by(1)
  end

  it "should not create questionnaire without qfounder" do
    q = Questionnaire.new(@attr)
#   q.qfounders.build(@fdr)
    q.valid?.should be_false
    q.errors.size.should == 1
  end

  it "should require a lastname" do
    noname_ques = Questionnaire.new(@attr.merge(:lastname => ""))
    noname_ques.should_not be_valid
  end

  it "should require a companyname" do
    no_compname_ques = Questionnaire.new(@attr.merge(:companyname => ""))
    no_compname_ques.should_not be_valid
  end

  it "should require a description" do
    nodesc_ques = Questionnaire.new(@attr.merge(:description => ""))
    nodesc_ques.should_not be_valid
  end

  it "should reject long description" do
    long_ques = Questionnaire.new(@attr.merge(:description => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should reject long businessplan" do
    long_ques = Questionnaire.new(@attr.merge(:businessplan => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should reject long competition" do
    long_ques = Questionnaire.new(@attr.merge(:competition => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should reject long team description" do
    long_ques = Questionnaire.new(@attr.merge(:team => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should reject long other projects" do
    long_ques = Questionnaire.new(@attr.merge(:other => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should reject long invest description" do
    long_ques = Questionnaire.new(@attr.merge(:invest => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should reject long advisor description" do
    long_ques = Questionnaire.new(@attr.merge(:advisor => "b" * 501))
    long_ques.should_not be_valid
  end

  it "should accept duplicate emails" do
#   ok for development, probably not okay for production
#   Questionnaire.create!(@attr)
    q = Questionnaire.new(@attr)
    q.qfounders.build(@fdr)
    q.save!
    dup_email_ques = Questionnaire.new(@attr)
    dup_email_ques.qfounders.build(@fdr)
    dup_email_ques.should be_valid
  end

  it "should accept valid emails" do
    emails = %w[user@foo.com The_User@foo.bar.org first.last@foo.jp]
    emails.each do |em|
      valid_email_ques = Questionnaire.new(@attr.merge(:email => em))
      valid_email_ques.qfounders.build(@fdr)
      valid_email_ques.should be_valid
    end
  end

  it "should reject invalid emails" do
    emails = %w[user@foo,com User_at_foo.org first.last@foo.]
    emails.each do |em|
      invalid_email_ques = Questionnaire.new(@attr.merge(:email => em))
      invalid_email_ques.should_not be_valid
    end
  end

end
