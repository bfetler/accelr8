require 'spec_helper'

describe "Accelerators" do

# before { sign_in FactoryGirl.create(:user) }
# before { sign_in FactoryGirl.create(:accelerator_user) }

  describe "failure" do
    it "should not make a new accelerator" do
      lambda do
        visit accelerators_path  # how does it know GET or POST ?
#       fill_in "Name*",      :with => ""
        fill_in "Email",      :with => ""
#       fill_in "City",      :with => ""
#       fill_in "State or Province",      :with => ""
#       fill_in "Start Date",      :with => ""
#       fill_in "Application Due Date",      :with => ""
#       fill_in "Length",      :with => "0"
#       fill_in "Website",      :with => ""
#       fill_in "Last name*",      :with => ""
#       fill_in "Description",      :with => ""
#       fill_in "We will accept late applications",      :with => ""
      end.should_not change(Accelerator, :count)
    end
  end

end
