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

  # GET /questionnaires/1
  # GET /questionnaires/1.xml
  def apply
    @questionnaire = Questionnaire.find(params[:id])

# used by accelerator/_list.html.erb
    if ! params[:column].nil?
      self.setsortorder()      # sort columns by param
      @accelerators = Accelerator.order(params[:column]+" "+flash[:sortorder])
    else
      @accelerators = Accelerator.all  # sort by index
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @questionnaire }
    end
  end

# utility to set column sort order by param
# copy of method from accelerators_controller
  def setsortorder
    if flash[:sortorder].nil?
      flash[:sortorder]="ASC"
    else  # swap sort order
      if flash[:sortorder]=="DESC"
        flash[:sortorder]="ASC"
      else
        flash[:sortorder]="DESC"
      end
    end
    if ! flash[:sortcolumn].nil?
#     if column changed, reset to ASC
      if flash[:sortcolumn] != params[:column]
        flash[:sortorder]="ASC"
      end
    end
    flash[:sortcolumn] = params[:column]
  end    # setcolumn utility

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
        format.html { redirect_to(@questionnaire, :notice => 'Founders Application was successfully created.') }
        format.xml  { render :xml => @questionnaire, :status => :created, :location => @questionnaire }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
      end
    end
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

# method works okay
# set all previous qfounders into oldlist
        oldlist = []
        @questionnaire.qfounders.each do |qf|
          oldlist << qf
        end
# create/update new qfounders
        params['qfounder'].each { |i, fdr|
          do_update = 1
          fdr.each { |j, fval|
            if fval != ""   # check if any value is non-empty
              do_update = 0
            end
          }
          if do_update == 0
            oqf = oldlist.first
            if ! oqf.nil?   # update old founder
              if ! oqf.update_attributes(fdr)
                saveerr = 0
              end
              oldlist.delete(oqf)
            else            # create new founder
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
# end method

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

# output flash msg only, action above format
    if params['qfounder'].any?

# method works okay - flash output
        flash[:notice] += " OLD OLD "
        oldlist = []
# set all previous qfounders into oldlist
        @questionnaire.qfounders.each do |qf|
          oldlist << qf
#         flash[:notice] += " old " + qf.lastname
        end
# create/update new qfounders
        params['qfounder'].each { |i, fdr|
          flash[:notice] += " fdr" + i.to_s + " "
          do_update = 1
          fdr.each { |j, fval|
            if fval != ""   # check if any value is non-empty
              do_update = 0
            end
          }
          if do_update == 0
            oqf = oldlist.first
            if ! oqf.nil?   # update old founder
              flash[:notice] += " update fdr " + oqf.lastname + " > " + fdr.fetch("lastname") + " "
#             if ! oqf.update_attributes(fdr)
#               saveerr = 0
#             end
              oldlist.delete(oqf)
            else            # create new founder
              flash[:notice] += " create fdr " + fdr.fetch("lastname") + " "
#             @qfdr = Qfounder.new(fdr)
#             @qfdr.questionnaire_id = @questionnaire.id
#             if ! @qfdr.save
#               saveerr = 0
#             end
            end
          end
        }  # end params['qfounder'].each
        flash[:notice] += " oldlist.size " + oldlist.size.to_s + " "
        oldlist.each do |oqf|
          flash[:notice] += "del " + oqf.id.to_s + " "
        end
# end method

    end

#   flash[:notice] += params['qfounder'].count.to_s + " xx " + params['questionnaire'].inspect
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
#   flash[:notice] = "try destroy questionnaire"
  end
end
