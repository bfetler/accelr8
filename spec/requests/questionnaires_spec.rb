require 'spec_helper'

describe "Integration: Create Questionnaires" do

  before do
    @user = FactoryGirl.create(:user)
    visit 'users/sign_in'
    fill_in "Email",      :with => @user.email
    fill_in "Password",   :with => @user.password
    click_button
  end

  describe "failure" do
    it "should not make a new questionnaire" do
      lambda do
        visit accelerators_path  # how does it know GET or POST ?
        click_button "Apply to Accelerators"
        fill_in "Company Name",               :with => ""
        fill_in "First name",                 :with => ""
        fill_in "Last name",                  :with => ""
        fill_in "Email",                      :with => ""
        fill_in "qfounder[0][firstname]",     :with => ""
        fill_in "qfounder[0][lastname]",      :with => ""
        fill_in "qfounder[0][role]",          :with => ""
        fill_in "qfounder[0][weblink]",       :with => ""
        fill_in "questionnaire[description]", :with => ""
        click_button
        response.should render_template('new')
        response.should have_selector("li", :content => "Name can't be blank")
      end.should_not change(Questionnaire, :count)
    end
  end

  describe "success" do
    it "should make a new accelerator" do
      lambda do
        visit accelerators_path
        click_button "Create New Accelerator"
        fill_in "Name",              :with => "Test Accelerator"
        fill_in "Email",             :with => "george@jetson.com"
        fill_in "City",              :with => "Seattle"
        fill_in "State or Province", :with => "WA"
        select_date 9.days.from_now, :from => "Start Date"
        select_date 2.days.from_now, :from => "Application Due Date"
        fill_in "Length",            :with => "6"
        fill_in "Website",           :with => "http://www.jetson.com"
        fill_in "Last name",         :with => "Jetson"
        fill_in "accelerator[description]",         :with => "Send yer ideas."
        fill_in "We will accept late applications", :with => "Yes"
        click_button
        response.should render_template('accelerators')
      end.should change(Accelerator, :count).by(1)
    end
  end

end
