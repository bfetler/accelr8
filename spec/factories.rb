FactoryGirl.define do
  factory :user do
#   sequence(:name) { |n| "Person #{n}" }
#   sequence(:email) { |n| "person_#{n}@example.com"}
    email    "my.email@foo.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :accelerator_user do
    name     "Angel Accelerator"
    email    "angel@accelerator.com"
    password "apassword"
    password_confirmation "apassword"
  end

  factory :questionnaire do
    sequence(:firstname)   { |n| "George #{n}" }
    sequence(:lastname)    { |n| "Jetson #{n}" }
    sequence(:companyname) { |n| "Robotics #{n}" }
    sequence(:email)       { |n| "quest_#{n}@example.com"}
    website      "http://www.google.com"
    webvideo     "http://www.youtube.com"
    description  "Description."
    businessplan "Business plan."
    competition  "Competitors."
    team         "George and Jane Jetson."
    other        "Other projects."
    invest       "Investors."
    advisor      "Advisors."
# missing qfounder
  end

  factory :accelerator do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "accelerator#{n}@example.com"}
    city "San Francisco"
    state "CA"
    startdate 7.days.from_now
    duedate 0.days.from_now
    length "8"
    website "http://www.google.com"
    lastname "Flintstone"
    description "Flinstone accelerator."
    acceptlate "no"
  end

end
