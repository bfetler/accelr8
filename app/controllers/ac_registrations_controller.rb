class AcRegistrationsController < ApplicationController

  # GET /registrations
  # GET /registrations.xml
  def index
#   if is_admin?
    @registrations = AcRegistration.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registrations }
    end
#   end  # is_admin
  end

  # POST /registrations
  # POST /registrations.xml
# def create    # original create
#   @registration = AcRegistration.new(params[:registration])

#   respond_to do |format|
#     if @registration.save
#       format.html { redirect_to(@registration, :notice => 'Registration was successfully created.') }
#       format.xml  { render :xml => @registration, :status => :created, :location => @registration }
#     else
#       format.html { render :action => "new" }
#       format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
#     end
#   end
# end

  def get_acc_filename
    acc_file = "tmp/maild/acc_file_" + Time.now.strftime('%Y%m%dT%H%M%S')
  end

  def makeacfile(acc_file, ques)  # create acc_file
    dname = File.dirname(acc_file)
    if !File.exists?(dname)
      Dir.mkdir(dname)
    end
    rmacfile(acc_file)  # make sure it doesn't exist
    f = File.open(acc_file, mode="w+")
    @questionnaire = ques
#   @url = "http://foundershookup.com"
    f.write( render_to_string :template => "ac_mailer/txt_quest.text" )
    f.close
  end

  def rmacfile(acc_file)  # remove acc_file
    if File.exists?(acc_file)
      File.delete(acc_file)
    end
#   doesn't always work?
  end

  def testemail       # test email application
    if (params['quid'] != '-1' )
      ques = Questionnaire.find(params['quid'])  # only needed for email
      acc_file = get_acc_filename
      makeacfile(acc_file, ques)
      AcMailer.test_email(ques, acc_file).deliver
      rmacfile(acc_file)
      respond_to do |format|
        format.html { redirect_to(:back) }
        flash[:notice] = ques.companyname + " test application sent to: " + ques.email + "."
      end
    end
  end

  # POST /registrations
  # POST /registrations.xml
  def createbatch       # create batch registrations
#   if is_admin?
    if (!params['bx'].nil? && params['bx'].any? && params['quid'] != '-1' )
#     params['bx'] etc. => some registration check boxes selected
      savect  = 0
      saveerr = nil

      ques = Questionnaire.find(params['quid'])  # needed for email
      if !ques.nil?
        acc_names  = []
#       acc_emails = []
        acc_file = get_acc_filename
        makeacfile(acc_file, ques)

#       puts 'controller bx: ' + params['bx'].inspect
        params['bx'].each_key do |i|
          acc = Accelerator.find(i)
          if !acc.nil?
            acc_names << acc.to_s
            if ((!acc.acceptapp.nil?   && acc.acceptapp == "Yes") &&
                (!acc.acceptemail.nil? && !acc.acceptemail.empty?))
#             acc_emails << acc.acceptemail
              acc_email = acc.acceptemail
            else
#             acc_emails << acc.email
              acc_email = acc.email
            end

            @registration = AcRegistration.new(params[:registration])
            @registration.questionnaire_id = params['quid']
            @registration.accelerator_id = i
# don't actually need to save registration, as long as email sent?
            if @registration.save
# what happens if email delivery fails?
              AcMailer.register_email(ques, acc_email, acc_file).deliver
              savect += 1
            else
              saveerr = 0
            end   # if @registration.save

          end  # !acc.nil?
        end  # params['bx'].each_key do |i|

        if saveerr.nil? && acc_names.length > 0
#         AcMailer.register_email(ques, acc_emails, acc_file).deliver
          AcMailer.quest_email(ques, acc_names, acc_file).deliver
        end

        rmacfile(acc_file)
      end  # !ques.nil?

#     rstr = ''
      respond_to do |format|
        if saveerr.nil?   # no errors in saving registration
#         format.html { redirect_to(apply_questionnaire_path(ques)) }
          format.html { redirect_to(:back) }
          format.xml  { render(:xml => ques, :status => :created, :location => ques) }
#         (savect<1.5) ? rstr += 'Registration' : rstr += 'Registrations'
#         rstr += ' successfully created.'
          flash[:notice] = ques.companyname + " application sent to: "
          flash[:notice] += acc_names.join(", ") + "."
#         flash[:notice] += params['bx'].map { |t, v|
#           acc = Accelerator.find(t)
#           if !acc.nil?
#             acc.to_s
#           end
#         }.join(", ")
#         flash[:notice] += "."
#         flash[:notice] += " accemails: " + acc_emails.join(", ")
#         flash[:notice] += ". qemail: " + ques.email
#         flash[:notice] += ". acc_file " + File.absolute_path(acc_file)

        else  # if saveerr.nil?  # some errors in saving registration
          format.html { redirect_to(:back) }
          format.xml  { render :xml => ques.errors, :status => :unprocessable_entity }
          flash[:notice] = "Error creating registrations.  Please contact Founders Hookup for assistance."
        end
      end   # respond_to do |format|

    else  # if !params['bx'].nil?  # no registration check boxes selected
      respond_to do |format|
        format.html { redirect_to(:back) }
        format.xml  { render(:xml => ques, :status => :created, :location => ques) }
        flash[:notice] = "Please select 'Apply Now' check boxes to apply to accelerators."
      end   # respond_to do |format|
    end   # if !params['bx'].nil?

# flash[:notice] = rstr
# flash debug messages
    if (!params['bx'].nil? && params['bx'].any? && params['quid'] != '-1' )
      flash[:notice] += " BX count " + params['bx'].count.to_s + " " + params['bx'].inspect

    end   # if !params['bx'].nil?
#   end  # is_admin

  end  # def createbatch

  # DELETE /registrations/1
  # DELETE /registrations/1.xml
# def destroy
#   @registration = AcRegistration.find(params[:id])
#   @registration.destroy
#
#   respond_to do |format|
#     format.html { redirect_to(registrations_url) }
#     format.xml  { head :ok }
#   end
# end

  # DELETE /registrations
  # DELETE /registrations.xml
  def destroybatch
#   if is_admin?
    if (!params['bx'].nil? && params['bx'].any?)
      params['bx'].each do |i|
        reg_id = i.to_s
        @registration = AcRegistration.find(reg_id)
        @registration.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to( :back ) }
#     format.html { redirect_to(:controller => "registrations", :action => "index") }
      format.xml  { head :ok }
    end

# flash messages
#   flash[:notice] = "flash destroybatch registration " + params.inspect
    if (!params['bx'].nil? && params['bx'].any?)
      (params['bx'].size<1.5) ? rstr = 'id' : rstr = 'ids'
      flash[:notice] = "Delete batch registration " + rstr + ": "
      flash[:notice] += params['bx'].map { |t, v| t.to_s }.join(", ")
    else
      flash[:notice] = "Click the check boxes to select registrations to delete."
    end
#   end  # is_admin

  end  # def destroybatch

end
