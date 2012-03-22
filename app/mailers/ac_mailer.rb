class AcMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  sendgrid_enable   :ganalytics, :opentrack

  default :from => "test_support@foundershookup.com"
# could have a different from address

# to get email to work, how do we to set up a mail server?
# SendGrid

# method names match files in app/views/ac_mailer
  def test_email(ques)
    @questionnaire = ques
    @url = "http://foundershookup.com"
    @support_email = "test_support@foundershookup.com"
    @support_phone = "+1-415-309-8860"

    mail( :to => ques.email,
      :subject => "accelerator test email"
    )
  end

  def quest_email(ques, acc_names, acfile)

    sendgrid_category "accelerator"
    @questionnaire = ques
    if (! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
      @support_phone = "+1-415-309-8860"

      @acnames = acc_names  # set accelerator names in view

      if (! @questionnaire.email.nil? && ! @questionnaire.email.empty?)
        attachments['application.txt'] = File.read(acfile)
        mail(:to => @questionnaire.email,
             :subject => "accelerator application")
      else  # application email not set (can't happen, it's required)
        mail(:to => @support_email,
             :subject => "application email not set")
      end
# spawn email as separate thread?
    end
  end

  def register_email(ques, acc_emails)
# what do I want it to do?  send one or multiple emails?

    sendgrid_category "accelerator"
    @questionnaire = ques
    if (! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
      @support_phone = "+1-415-309-8860"

# set accelerator email address
      ac_email = acc_emails.join(", ")
#     ac_email = (acc_emails << @questionnaire.email).join(", ")

      if (! ac_email.nil? && ! ac_email.empty?)
# cannot call mail() twice in one deliver, goes to text
        mail(:to => ac_email,
             :subject => "founders hookup application")
#       mail(:bcc => ac_email, :subject => "accelerator application")
#       in gmail, bcc-only gives "to undisclosed recipients", needs :to
      else  # accelerator email not set (shouldn't happen, it's required)
        mail(:to => @support_email,
             :subject => "accelerator email not set")
      end
# could use File to send attachment (see ruby docs)
# spawn email as separate thread?
    end
  end

  def register_email_old(ac_id, ques)

    sendgrid_category "accelerator"
    @questionnaire = ques
    @accel = Accelerator.find(ac_id)
    if (! @accel.nil? && ! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
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
