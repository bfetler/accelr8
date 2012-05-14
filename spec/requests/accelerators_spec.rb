require 'spec_helper'

describe "Integration: Accelerators" do

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
#       fill_in "Start Date",            :with => ""
#       fill_in "Application Due Date",  :with => ""
        fill_in "Length",            :with => "0"
        fill_in "Website",           :with => ""
        fill_in "Last name",         :with => ""
#       fill_in "Description: Please describe the accelerator in 2 - 3 sentences.",      :with => ""
        fill_in "We will accept late applications", :with => ""
        click_button
      end.should_not change(Accelerator, :count)
    end
  end

end
