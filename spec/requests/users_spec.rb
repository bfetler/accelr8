require 'spec_helper'

describe "Integration: Users" do

  describe "Create User" do
    describe "failure" do
      it "should not create a new user" do
        lambda do
          visit 'users/sign_in'
          click_link "Create New User"
          fill_in "Email",      :with => ""
          fill_in "Password",   :with => ""
          fill_in "Password confirmation",   :with => ""
          click_button
          response.should render_template('users')
          response.should have_selector("li", :content => "Email can't be blank")
          response.should have_selector("li", :content => "Password can't be blank")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should create a new user" do
        lambda do
          visit 'users/sign_in'
          click_link "Create New User"
          response.should render_template('users')
          fill_in "Email",      :with => "george@jetson.com"
          fill_in "Password",   :with => "jaaaane"
          fill_in "Password confirmation",   :with => "jaaaane"
          click_button
          response.should render_template('accelerators')
          response.should have_selector("div", :content => "Accelerator Directory")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "User Login" do

    before { @user = FactoryGirl.create(:user) }

    describe "failure" do
      it "should not log in an invalid user" do
        lambda do
#         visit users_path  # how does it know GET or POST ?
          visit 'users/sign_in'
          fill_in "Email",      :with => ""
          fill_in "Password",   :with => ""
          click_button
          response.should render_template('users/sessions/new')
          response.should have_selector("p", :content => "Invalid email or password.")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should log in a factory user" do
        lambda do
          visit 'users/sign_in'
          fill_in "Email",      :with => @user.email
          fill_in "Password",   :with => @user.password
          click_button
          response.should render_template('accelerators')
          response.should have_selector("div", :content => "Accelerator Directory")
          response.should have_selector("div", :content => "Logged in successfully.")
        end.should_not change(User, :count)
      end
    end

  end
end
