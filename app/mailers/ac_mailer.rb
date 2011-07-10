class AcMailer < ActionMailer::Base
  default :from => "from@rails.example.com"
# replace w/ support@foundershookup.com ?

# to get email to work, do we need to set up mail server?

# method name matches file names in app/views/ac_mailer
  def register_email(ac_id, ques)
    @questionnaire = ques
    @accel = Accelerator.find(ac_id)
    if (! @accel.nil? && ! @questionnaire.nil?)
      @url = "http://rubyonrails.org"
      if ((! @accel.acceptapp.nil?   && @accel.acceptapp == "Yes") &&
          (! @accel.acceptemail.nil? && ! @accel.acceptemail.empty?))
        ac_email = @accel.acceptemail
      else
        ac_email = @accel.email
      end
      if (! ac_email.nil? && ! ac_email.empty?)
        mail(:to => ac_email,
             :subject => "accelerator application")
      end
      if (! @questionnaire.email.nil? && ! @questionnaire.email.empty?)
        mail(:to => @questionnaire.email,
             :subject => "accelerator application")
      end
# could use File to send attachment (see ruby docs)
# spawn email as separate thread?
    end
  end

end
