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

  def quest_email(ques, acc_names, acc_file)

    sendgrid_category "accelerator"
    @questionnaire = ques
    if (! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
      @support_phone = "+1-415-309-8860"

      @acnames = acc_names  # set accelerator names in view

#     acc_file = 'public/acc_file'
#     f = File.open(acc_file, mode="w+")
#     f.write("Accelerator Application File\n")
#     acout = render :template => "ac_mailer/txt_quest.text"
#     acout = render_to_string :template => "ac_mailer/txt_quest.text"
#     f.write(acout)
#     f.close

      if (! @questionnaire.email.nil? && ! @questionnaire.email.empty?)
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

  def register_email(ques, acc_emails, acc_file)
# what do I want it to do?  send one or multiple emails?

    sendgrid_category "accelerator"
    @questionnaire = ques
    if (! @questionnaire.nil?)
      @url = "http://foundershookup.com"
      @support_email = "test_support@foundershookup.com"
      @support_phone = "+1-415-309-8860"

# temporarily generate my_file
#     my_file = 'public/myfile_'
#     if File.exists?(my_file)
#       File.delete(my_file)
#     end
#     f = File.open(my_file, mode='w+')
#     acout = render_to_string :template => "ac_mailer/txt_quest.text"
#     f.write(acout)
#     f.close

# set accelerator email address
      ac_email = acc_emails.join(", ")

      if (! ac_email.nil? && ! ac_email.empty?)
        attachments['application.txt'] = File.read(acc_file)
#       attachments['application.txt'] = File.read(my_file)
# cannot call mail() twice in one deliver, goes to text

# below doesn't seem to work, syntax?
#   X-SMTPAPI: {"filters": {"ganalytics": {"settings": {"enable":0}}, "opentrack": {"settings": {"enable":0}} }}
#   headers({'X-SMTPAPI' => {'filters': {'ganalytics': {'settings': {'enable':0} }, 'opentrack': {'settings': {'enable':0} } }  } })
#   smtp_settings( 'filters': {'ganalytics': {'settings': {'enable':0} }, 'opentrack': {'settings': {'enable':0} } }  )

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
