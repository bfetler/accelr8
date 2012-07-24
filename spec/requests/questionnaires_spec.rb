require 'spec_helper'

describe "Integration: Create Questionnaires" do

  before do
    user = FactoryGirl.create(:user)
    visit 'users/sign_in'
    fill_in "Email",      :with => user.email
    fill_in "Password",   :with => user.password
    click_button

    accel_user = FactoryGirl.create(:accelerator_user)
    visit accelerators_path
    click_link "Accelerator Login"
    fill_in "Accelerator Email", :with => accel_user.email
    fill_in "Password",          :with => accel_user.password
    click_button

#   FactoryGirl.create(:accelerator, :accelerator_user => accel_user)
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

# log out accelerator user, log in user   # complains about devise route
#   click_link "Log out"
#   fill_in "Email",      :with => user.email
#   fill_in "Password",   :with => user.password
#   click_button
  end

  describe "failure" do
    it "should not make a blank questionnaire" do
      lambda do
        visit accelerators_path
        click_button "Apply to Accelerators"
        fill_in "questionnaire[companyname]", :with => ""
        fill_in "First name",                 :with => ""
        fill_in "Last name",                  :with => ""
        fill_in "Email",                      :with => ""
        fill_in "qfounder[0][firstname]",     :with => ""
        fill_in "qfounder[0][lastname]",      :with => ""
        fill_in "qfounder[0][role]",          :with => ""
        fill_in "qfounder[0][weblink]",       :with => ""
        fill_in "questionnaire[description]", :with => ""
        click_button
# save_and_open_page
        response.should render_template('new')
        response.should have_selector("li", :content => "Companyname can't be blank")
        response.should have_selector("li", :content => "Need at least one Founder with first or last name")
      end.should_not change(Questionnaire, :count)
    end

    it "should not make a questionnaire without founder name" do
      lambda do
        visit accelerators_path
        click_button "Apply to Accelerators"
        fill_in "questionnaire[companyname]", :with => "Fred's Burgers"
        fill_in "First name",                 :with => "Fred"
        fill_in "Last name",                  :with => "Flintstone"
        fill_in "Email",                      :with => "fred@flintstone.com"
        fill_in "qfounder[0][firstname]",     :with => ""
        fill_in "qfounder[0][lastname]",      :with => ""
        fill_in "qfounder[0][role]",          :with => "chef"
        fill_in "qfounder[0][weblink]",       :with => "http://www.linked-in/f"
        fill_in "questionnaire[description]", :with => "Brontosaurus burgers!"
        click_button
        response.should render_template('new')
        response.should have_selector("li", :content => "Need at least one Founder with first or last name")
      end.should_not change(Questionnaire, :count)
    end
  end

  describe "success" do
    it "should make a new questionnaire" do
      lambda do
        visit accelerators_path
        click_button "Apply to Accelerators"
        fill_in "questionnaire[companyname]", :with => "Fred's Burgers"
        fill_in "First name",                 :with => "Fred"
        fill_in "Last name",                  :with => "Flintstone"
        fill_in "Email",                      :with => "fred@flintstone.com"
        fill_in "qfounder[0][firstname]",     :with => "Fred"
        fill_in "qfounder[0][lastname]",      :with => "Flintstone"
        fill_in "qfounder[0][role]",          :with => "chef"
        fill_in "qfounder[0][weblink]",       :with => ""
        fill_in "questionnaire[description]", :with => "Brontosaurus burgers!"
        click_button
        response.should render_template('show')
      end.should change(Questionnaire, :count).by(1)
    end
  end

end
