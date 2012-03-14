# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Accelr8::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 	"bkfetler",
  :password => 		"m1s3nd1t",
  :domain => 		"fh-accel-test2.herokuapp.com",
  :address => 		"smtp.sendgrid.net",
  :port => 		"587",
  :authentication => 	:plain,
  :enable_starttls_auto => true
}
