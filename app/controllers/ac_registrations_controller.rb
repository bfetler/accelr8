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

  def testemail       # test email application
    if (params['quid'] != '-1' )
      ques = Questionnaire.find(params['quid'])  # only needed for email
#     AcMailer.send_test_email(ques.email).deliver
      AcMailer.test_email(ques).deliver
      respond_to do |format|
        format.html { redirect_to(:back) }
        flash[:notice] = "Test email: id " + ques.id.to_s
        flash[:notice] += ", email " + ques.email
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

      ques = Questionnaire.find(params['quid'])  # only needed for email

      params['bx'].each do |i|
        @registration = AcRegistration.new(params[:registration])
        @registration.questionnaire_id = params['quid']
#       @registration.accelerator_id = i.to_s
#         @registration.accelerator_id = i  # fails, always 1
#         accel = Accelerator.find(i)
#         @registration.accelerator_id = accel.id  # fails
          i.map { |t, v|
            if t.any?
              @registration.accelerator_id = t
            end
          }
# on heroku (postgres):  use 1st, always 0.  
# on local (sqlite3), 1st always correct.  

# don't actually need to save registration, as long as email sent?
        if @registration.save
          if ! ques.nil?
# what happens if email delivery fails?
            AcMailer.register_email(i.to_s, ques).deliver
#           AcMailer.register_email(i, ques).deliver
# if using AcMailer, heroku gives "page you were looking for doesn't exist"
          end
          savect += 1
        else
          saveerr = 0
        end   # if @registration.save
      end   # params['bx'].each do |i|

#     rstr = ''
      respond_to do |format|
        if saveerr.nil?   # no errors in saving registration
#         format.html { redirect_to(apply_questionnaire_path(ques)) }
          format.html { redirect_to(:back) }
          format.xml  { render(:xml => ques, :status => :created, :location => ques) }
#         (savect<1.5) ? rstr += 'Registration' : rstr += 'Registrations'
#         rstr += ' successfully created.'
          flash[:notice] = "  " + Questionnaire.find(params['quid']).companyname
          flash[:notice] += " application sent to: "
          params['bx'].each do |i|
            flash[:notice] += " X" + i.to_s + "X "
            i.map { |t, v|
              flash[:notice] += " M" + t + "M "
            }
          end
          flash[:notice] += params['bx'].map { |t, v|
            acc = Accelerator.find(t)
            if (acc.season.nil? || acc.season.empty?)
              acc.name
            else
              acc.name + " (" + acc.season + ")"
            end
          }.join(", ")
          flash[:notice] += "."
          flash[:notice] += " BX count " + params['bx'].count.to_s + " " + params['bx'].inspect

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
#   if (!params['bx'].nil? && params['bx'].any? && params['quid'] != '-1' )
#     flash[:notice] += " BX count " + params['bx'].count.to_s + " " + params['bx'].inspect

#   end   # if !params['bx'].nil?
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
