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
# let(:accel12) { { :one => FactoryGirl.create(:accelerator), :two => FactoryGirl.create(:accelerator)
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
#       bhash = Hash[ accelerators.each { |a| a }, "" ]
        accelerators.each { |a| puts '      ' + a.id.to_s + ': ' + a.name + ': ' + a.email }
        bhash = Hash.new
#       accelerators.each { |a| bhash[a.id] = "" }
        accelerators.each { |a| bhash[a.id.to_s] = "" }
#       puts bhash.to_s
        puts 'ctrl test bx: ' + bhash.inspect
        @request.env['HTTP_REFERER'] = 'http://0.0.0.0:3000/'
#       @request.env['HTTP_REFERER'] = 'http://0.0.0.0:3000/questionnaires/13/apply'
        post :createbatch, 'quid' => questionnaire.to_param, 'bx' => bhash
#       post :createbatch, 'quid' => questionnaire.to_param, 'bx' => bhash, {'HTTP_REFERER' => 'http://0.0.0.0:3000'}
#       No HTTP_REFERER was set in the request to this action, so redirect_to :back could not be called successfully. If this is a test, make sure to specify request.env["HTTP_REFERER"].
# to_param is id
#       post :createbatch, 'quid' => questionnaire.to_param, 'bx' => accelerators.map(&:to_param)
#       response.should be_success  # fails
       end.should change(AcRegistration, :count).by(3)
# only prints if count is incorrect
      end
    end
  end

end
