class QuestionnairesController < ApplicationController
  # GET /questionnaires
  # GET /questionnaires.xml
  def index
    @questionnaires = Questionnaire.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questionnaires }
    end
  end

  # GET /questionnaires/1
  # GET /questionnaires/1.xml
  def show
    @questionnaire = Questionnaire.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @questionnaire }
    end
  end

  # GET /questionnaires/new
  # GET /questionnaires/new.xml
  def new
    @questionnaire = Questionnaire.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @questionnaire }
    end
  end

  # GET /questionnaires/1/edit
  def edit
    @questionnaire = Questionnaire.find(params[:id])
  end

  # POST /questionnaires
  # POST /questionnaires.xml
  def create
    saveerr = nil

    @questionnaire = Questionnaire.new(params[:questionnaire])
    if ! @questionnaire.save
      saveerr = 0
    else
# no save errors for questionnaire, try saving qfounders
      if params['qfounder'].any?
        params['qfounder'].each { |i, fdr|
# if non-empty lastname string, save qfounder
          if fdr.fetch("lastname", "").match('[A-z]+')
            @qfdr = Qfounder.new(fdr)
            @qfdr.questionnaire_id = @questionnaire.id
            if ! @qfdr.save
              saveerr = 0
            end
          end
        }
      end
    end

    respond_to do |format|
      if saveerr.nil?    # no errors saving questionnaire
        format.html { redirect_to(@questionnaire, :notice => 'Questionnaire was successfully created.') }
        format.xml  { render :xml => @questionnaire, :status => :created, :location => @questionnaire }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
      end
    end

#   flash[:notice] = "flash create: " + params['questionnaire'].inspect
  end

  # PUT /questionnaires/1
  # PUT /questionnaires/1.xml
  def update
#   flash[:notice] = "flash update: "
    saveerr = nil
    @questionnaire = Questionnaire.find(params[:id])
    if ! @questionnaire.update_attributes(params[:questionnaire])
      saveerr = 0
    else
# no save errors for questionnaire, try saving qfounders
      if params['qfounder'].any?
#
# method A
## delete all previous qfounders
#       @questionnaire.qfounders.each do |qfdr|
#         qfdr.destroy
#       end
#       params['qfounder'].each { |i, fdr|
## if non-empty lastname string, save qfounder
#         if fdr.fetch("lastname", "").match('[A-z]+')
#           @qfdr = Qfounder.new(fdr)
#           @qfdr.questionnaire_id = @questionnaire.id
#           if ! @qfdr.save
#             saveerr = 0
#           end
#         end
#       }
# end method A
#
# method C
#   similar to method A/B, except create array of old qfdr as in B.
#   loop through new fdr, call update and delete (1) from array.
#   if any left in array at end, just delete.
#   don't need to compare all attrs.
#   it may give some unnecessary updates, but easier to keep track.
# end method C
#
# method B
# works but it sure is ugly
# set all previous qfounders into oldlist
        oldlist = []
        @questionnaire.qfounders.each do |qf|
          oldlist << qf
        end
# create/update new qfounders
        params['qfounder'].each { |i, fdr|
          if fdr.fetch("lastname", "").match('[A-z]+')  # non-empty string
            updated = 1
            fdrf = fdr.fetch("firstname")
            fdrl = fdr.fetch("lastname")
            fdrw = fdr.fetch("weblink")
            fdrr = fdr.fetch("role")
            fdrc = fdr.fetch("willcode")
            oldlist.each do |qf|
              if (fdrf == qf.firstname && fdrl == qf.lastname)
                updated = 0
                if ! (fdrw==qf.weblink && fdrr==qf.role && fdrc==qf.willcode)
#               if (fdrw != qf.weblink || fdrr != qf.role)
#                 not all attributes match, update entry
                  if ! qf.update_attributes(fdr)
                    saveerr = 0
                  end
#               else  # no attributes changed
                end
                oldlist.delete(qf)  # delete matched entry from oldlist
                break
              end
            end   # oldlist.each do
            if updated > 0  # params not found in oldlist, save new entry
              @qfdr = Qfounder.new(fdr)
              @qfdr.questionnaire_id = @questionnaire.id
              if ! @qfdr.save
                saveerr = 0
              end
            end
          end
        }
        oldlist.each do |qf|
          qf.destroy   # delete any remaining old founders
        end
# end method B

      end  # if params['qfounder'].any?
    end

    respond_to do |format|
      if saveerr.nil?    # no errors saving questionnaire
        format.html { redirect_to(@questionnaire, :notice => 'Questionnaire was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
      end
    end

#   flash[:notice] += params['qfounder'].count.to_s + " xx " + params.inspect
#   flash[:notice] = "flash update: " + params['questionnaire'].inspect
  end

  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.xml
  def destroy
    @questionnaire = Questionnaire.find(params[:id])
    @questionnaire.destroy
# also destroys qfounders

    respond_to do |format|
      format.html { redirect_to(questionnaires_url) }
      format.xml  { head :ok }
    end
  end
end
