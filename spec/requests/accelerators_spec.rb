require 'spec_helper'

describe "Integration: Create Accelerators" do

  before do
    @user = FactoryGirl.create(:user)
    visit 'users/sign_in'
    fill_in "Email",      :with => @user.email
    fill_in "Password",   :with => @user.password
    click_button
    @accel_user = FactoryGirl.create(:accelerator_user)
    visit accelerators_path
    click_link "Accelerator Login"
    fill_in "Accelerator Email", :with => @accel_user.email
    fill_in "Password",          :with => @accel_user.password
    click_button
  end

  describe "failure" do
    it "should not make a new accelerator" do
      lambda do
        visit accelerators_path  # how does it know GET or POST ?
        click_button "Create New Accelerator"
        fill_in "Name",              :with => ""
        fill_in "Email",             :with => ""
        fill_in "City",              :with => ""
        fill_in "State or Province", :with => ""
#       select_date 0.days.from_now, :id_prefix => "accelerator_startdate"
        select_date 0.days.from_now, :from => "Start Date"
        select_date 0.days.from_now, :from => "Application Due Date"
        fill_in "Length",            :with => "0"
        fill_in "Website",           :with => ""
        fill_in "Last name",         :with => ""
        fill_in "accelerator[description]",         :with => ""
        fill_in "We will accept late applications", :with => ""
        click_button
        response.should render_template('accelerators')
        response.should have_selector("li", :content => "Name can't be blank")
      end.should_not change(Accelerator, :count)
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
