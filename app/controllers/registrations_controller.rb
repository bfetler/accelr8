class RegistrationsController < ApplicationController
  # GET /registrations
  # GET /registrations.xml
  def index
    @registrations = Registration.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registrations }
    end
  end

  # POST /registrations
  # POST /registrations.xml
# def create    # original create
#   @registration = Registration.new(params[:registration])

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

  # POST /registrations
  # POST /registrations.xml
  def createbatch       # create batch registrations
    if (!params['bx'].nil? && params['bx'].any? && params['quid'] != '-1' )
#     params['bx'] etc. => some registration check boxes selected
      savect  = 0.0   # savect  or @savect ?
      saveerr = nil   # saveerr or @saveerr ?

      ques = Questionnaire.find(params['quid'])  # only needed for email

      params['bx'].each do |i|
        @registration = Registration.new(params[:registration])
        @registration.questionnaire_id = params['quid']
        @registration.accelerator_id = i.to_s

# don't actually need to save registration, as long as email sent?
        if @registration.save
          if ! ques.nil?
            AcMailer.register_email(i.to_s, ques).deliver
          end
          savect += 1.0
        else
          saveerr = 0
        end   # if @registration.save
      end   # params['bx'].each do |i|

      rstr = ''
      respond_to do |format|
        if saveerr.nil?   # no errors in saving registration
#           rstr = 'Registration'
#           if savect>1.5
#             rstr = rstr.pluralize
#           end
#           rstr += ' successfully created.'
          (savect<1.5) ? rstr += 'Registration' : rstr += 'Registrations'
          rstr += ' successfully created.'
          format.html { redirect_to(:back, :notice => rstr) }
          format.xml  { render(:xml => @questionnaire, :status => :created, :location => @questionnaire) }
        else  # if @saveerr.nil?  # some errors in saving registration
          format.html { render(:controller => "founder", :action => "show", :id => @registration.founder_id) }
          format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
        end   # if @saveerr.nil?
      end   # respond_to do |format|

    else  # if !params['bx'].nil?  # no registration check boxes selected
      respond_to do |format|
        format.html { redirect_to(:back) }
        format.xml  { render(:xml => @questionnaire, :status => :created, :location => @questionnaire) }
      end   # respond_to do |format|
    end   # if !params['bx'].nil?

#   flash[:notice] = rstr
# flash debug messages
    if (!params['bx'].nil? && params['bx'].any? && params['quid'] != '-1' )
#     flash[:notice] += " BX count " + params['bx'].count.to_s + " " + params['bx'].inspect

      flash[:notice] = "  " + Questionnaire.find(params['quid']).companyname
      flash[:notice] += " applied to: "
      flash[:notice] += params['bx'].map { |t, v|
        acc = Accelerator.find(t)
        if (acc.season.nil? || acc.season.empty?)
          acc.name
        else
          acc.name + " (" + acc.season + ")"
        end
      }.join(", ")
      flash[:notice] += "."

    end   # if !params['bx'].nil?

  end  # def createbatch

  # DELETE /registrations/1
  # DELETE /registrations/1.xml
# def destroy
#   @registration = Registration.find(params[:id])
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
    if (!params['bx'].nil? && params['bx'].any?)
      params['bx'].each do |i|
        reg_id = i.to_s
        @registration = Registration.find(reg_id)
        @registration.destroy
      end
    end

    respond_to do |format|
#     format.html { redirect_to(registrations_url) }
      format.html { redirect_to(:back, :notice => params) }
#         format.html { redirect_to(:back, :notice => rstr) }
      format.xml  { head :ok }
    end

# flash messages
#   flash[:notice] = "flash destroybatch registration " + params.inspect
    if (!params['bx'].nil? && params['bx'].any?)
      (params['bx'].size<1.5) ? rstr = 'id' : rstr = 'ids'
      flash[:notice] = "Delete batch registration " + rstr + ": "
      flash[:notice] += params['bx'].map { |t, v| t.to_s }.join(", ")
    end

  end  # def destroybatch

end
