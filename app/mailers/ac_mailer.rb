class AcMailer < ActionMailer::Base
  include SendGrid
# register at SendGrid to send mail
# sendgrid_enable   :ganalytics, :opentrack   # overrides account settings?
  sendgrid_category :use_subject_lines

# set default fields
  default :from => "test_support@foundershookup.com"

# method names match files in app/views/ac_mailer
  def test_email(ques, acc_file)
    sendgrid_category "customer_test"

    @questionnaire = ques
    @url = "http://foundershookup.com"
    @support_email = "test_support@foundershookup.com"
    @support_phone = "+1-415-309-8860"

    attachments['application.txt'] = File.read(acc_file)
    mail( :to => ques.email,
      :subject => "accelerator test email"
    )
  end

  def quest_email(ques, acc_names, acc_file)

    sendgrid_category "questionnaire"
    @questionnaire = ques
    if (! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
      @support_phone = "+1-415-309-8860"

      @acnames = acc_names  # set accelerator names in view

      if (! @questionnaire.email.nil? && ! @questionnaire.email.empty?)
#       headers['X-SMTPAPI'] = '{"category": "accelerator", "filters": {"opentrack": {"settings": {"enable":1}} }}'  #remove filters, extra char from attachment

        attachments['application.txt'] = File.read(acc_file)
        mail(:to => @questionnaire.email,
             :subject => "accelerator application")
      else  # application email not set (can't happen, it's required)
        mail(:to => @support_email,
             :subject => "application email not set")
      end
# spawn email as separate thread?
    end
  end

  def register_email(ques, acc_email, acc_file)
# what do I want it to do?  send one or multiple emails?

    sendgrid_category "accelerator"
    @questionnaire = ques
    if (! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
      @support_phone = "+1-415-309-8860"

# set accelerator email address
#     ac_email = acc_emails.join(", ")
      ac_email = acc_email

      if (! ac_email.nil? && ! ac_email.empty?)
#       headers['X-SMTPAPI'] = '{"category": "accelerator", "filters": {"opentrack": {"settings": {"enable":1}} }}'  #remove filters, extra char from attachment

        attachments['application.txt'] = File.read(acc_file)
# cannot call mail() twice in one deliver
        mail(:to => ac_email,
             :subject => "founders hookup application")
#       mail(:bcc => ac_email, :subject => "accelerator application")
#       in gmail, bcc-only gives "to undisclosed recipients"
      else  # accelerator email not set (shouldn't happen, it's required)
        mail(:to => @support_email,
             :subject => "accelerator email not set")
      end
# spawn email as separate thread?
    end
  end

end
