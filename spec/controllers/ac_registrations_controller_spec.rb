require 'spec_helper'

describe AcRegistrationsController do

  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:questionnaire) { FactoryGirl.create(:questionnaire) }
  let(:accelerators) { 3.times.each.map { FactoryGirl.create(:accelerator) } }

  before { sign_in user }

  describe "User Sign In" do
    it "should have a current user" do
      subject.current_user.should_not be_nil
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST createbatch" do
    describe "with three accelerators" do
      it "should create three registrations" do
        lambda do
          bhash = Hash.new{ |h, k| h[k] = "" }
          accelerators.each { |a| bhash[a.id.to_s] }
#         bhash = Hash[* accelerators.map { |a| [ a.id.to_s, "" ] }.flatten ]
#         redirect_to :back fails without HTTP_REFERER
          @request.env['HTTP_REFERER'] = 'http://0.0.0.0:3000/'
          post :createbatch, 'quid' => questionnaire.to_param, 'bx' => bhash
        end.should change(AcRegistration, :count).by(3)
      end
    end

    describe "with three accelerators, no questionnaire" do
      it "should fail to create registrations" do
        lambda do
          bhash = Hash.new{ |h, k| h[k] = "" }
          accelerators.each { |a| bhash[a.id.to_s] }
          @request.env['HTTP_REFERER'] = 'http://0.0.0.0:3000/'
          post :createbatch, 'bx' => bhash
        end.should_not change(AcRegistration, :count)
      end
    end

    describe "with no accelerators, one questionnaire" do
      it "should fail to create registrations" do
        lambda do
          @request.env['HTTP_REFERER'] = 'http://0.0.0.0:3000/'
          post :createbatch, 'quid' => questionnaire.to_param
        end.should_not change(AcRegistration, :count)
      end
    end
  end

end
