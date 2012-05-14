require 'spec_helper'

describe "Integration: Accelerator Users" do

  before do
    @user = FactoryGirl.create(:user)
    visit 'users/sign_in'
    fill_in "Email",      :with => @user.email
    fill_in "Password",   :with => @user.password
    click_button
  end

  describe "Create Accelerator User" do
    describe "failure" do
      it "should not create an invalid accelerator user" do
        lambda do
          visit accelerators_path
          click_link "Accelerator Login"
          click_link "Create New Accelerator Login"
          response.should render_template('accelerator_users')
          fill_in "Accelerator Name",  :with => ""
          fill_in "Accelerator Email", :with => ""
          fill_in "Password",          :with => ""
          fill_in "Password confirmation", :with => ""
          click_button
          response.should render_template('accelerator_users')
          response.should have_selector("li", :content => "Name can't be blank")
          response.should have_selector("li", :content => "Email can't be blank")
          response.should have_selector("li", :content => "Password can't be blank")
        end.should_not change(AcceleratorUser, :count)
      end
    end

    describe "success" do
      it "should create an accelerator user" do
        lambda do
          visit accelerators_path
          click_link "Accelerator Login"
          click_link "Create New Accelerator Login"
          response.should render_template('accelerator_users')
          fill_in "Accelerator Name",  :with => "My Accelerator"
          fill_in "Accelerator Email", :with => "elroy@jetson.com"
          fill_in "Password",          :with => "boyoboyoboy"
          fill_in "Password confirmation", :with => "boyoboyoboy"
          click_button
          response.should render_template('accelerator')
          response.should have_selector("div", :content => "Welcome! You have signed up successfully.")
        end.should change(AcceleratorUser, :count).by(1)
      end
    end
  end

  describe "Accelerator User Login" do
    before { @accel_user = FactoryGirl.create(:accelerator_user) }

    describe "failure" do
      it "should not log in an invalid accelerator user" do
        lambda do
          visit accelerators_path
          click_link "Accelerator Login"
          fill_in "Accelerator Email", :with => ""
          fill_in "Password",          :with => ""
          click_button
          response.should render_template('accelerator_users')
          response.should have_selector("p", :content => "Invalid email or password.")
        end.should_not change(AcceleratorUser, :count)
      end
    end

    describe "success" do
      it "should log in a factory accelerator user" do
        lambda do
          visit accelerators_path
          click_link "Accelerator Login"
          fill_in "Accelerator Email", :with => @accel_user.email
          fill_in "Password",          :with => @accel_user.password
          click_button
          response.should render_template('accelerators')
          response.should have_selector("div", :content => "Logged in successfully.")
        end.should_not change(AcceleratorUser, :count)
      end
    end
  end

end
