class AcMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  sendgrid_enable   :ganalytics, :opentrack

  default :from => "test_support@foundershookup.com"
# could have a different from address

# to get email to work, how do we to set up a mail server?
# SendGrid

# method name matches file names in app/views/ac_mailer
  def register_email(ac_id, ques)

    sendgrid_category "accelerator"
    @questionnaire = ques
    @accel = Accelerator.find(ac_id)
    if (! @accel.nil? && ! @questionnaire.nil?)
      @url = "http://foundershookup.com"
#     @support_email = "support@foundershookup.com"
      @support_email = "bfetler@gmail.com"
      @support_phone = "+1-415-309-8860"

# set accelerator email address
      if ((! @accel.acceptapp.nil?   && @accel.acceptapp == "Yes") &&
          (! @accel.acceptemail.nil? && ! @accel.acceptemail.empty?))
        ac_email = @accel.acceptemail
      else
        ac_email = @accel.email
      end

      if (! ac_email.nil? && ! ac_email.empty?)
# cc questionnaire application email if set
        if (! @questionnaire.email.nil? && ! @questionnaire.email.empty?)
          mail(:to => ac_email,
               :cc => @questionnaire.email,
               :subject => "accelerator application")
        else
# send email without cc
          mail(:to => ac_email,
               :subject => "accelerator application")
        end
      else  # accelerator email not set (shouldn't happen, it's required)
          mail(:to => @support_email,
               :subject => "accelerator email not set")
      end
# could use File to send attachment (see ruby docs)
# spawn email as separate thread?
    end
  end

end
