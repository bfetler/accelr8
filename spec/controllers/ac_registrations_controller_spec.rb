require 'spec_helper'

describe AcRegistrationsController do

  render_views

# before(:each) do
#   @user = { :email => "fred@flintstone.com",
#             :password => "abc123"
#           }
#   sign_in @user
# end

  let(:user) { FactoryGirl.create(:user) }
  let(:questionnaire) { FactoryGirl.create(:questionnaire) }
  let(:accelerators) { 3.times.each.map { FactoryGirl.create(:accelerator) } }
# let(:accels) { 3.times.each.map { { FactoryGirl.create(:accelerator), "" } } }

  before { sign_in user }

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
#         accelerators.each { |a| puts '      ' + a.id.to_s + ': ' + a.name + ': ' + a.email }
          bhash = Hash.new{ |h, k| h[k] = "" }
          accelerators.each { |a| bhash[a.id.to_s] }
#         bhash = Hash[* accelerators.map { |a| [ a.id.to_s, "" ] }.flatten ]
#         puts 'ctrl test bx: ' + bhash.inspect

# redirect_to :back fails without HTTP_REFERER
          @request.env['HTTP_REFERER'] = 'http://0.0.0.0:3000/'
          post :createbatch, 'quid' => questionnaire.to_param, 'bx' => bhash
#         post :createbatch, 'quid' => questionnaire.to_param, 'bx' => accelerators.map(&:to_param)  # fails w/ each_key in ctrlr, needs hash
        end.should change(AcRegistration, :count).by(3)
      end
    end
  end

end
