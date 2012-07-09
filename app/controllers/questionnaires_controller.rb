class QuestionnairesController < ApplicationController
  before_filter :authenticate_user!

  # GET /questionnaires
  # GET /questionnaires.xml
  def index
    @questionnaires = Questionnaire.all
#   @questionnaires = User.questionnaire.all

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
# used by accelerator/_list.html.erb

    @questionnaire = Questionnaire.find(params[:id])

    @sortcolumn = params[:column] ||= "startdate"
    @sortorder = params[:order] ||= "ASC"
    # sort columns by param
#   only show Accelerators that accept FH applications, by sort column order
#   @accelerators = Accelerator.where(:acceptapp => "Yes").order(@sortcolumn+" "+@sortorder)
    @accelerators = Accelerator.order(@sortcolumn+" "+@sortorder)

    respond_to do |format|
      format.html # apply.html.erb
      format.xml  { render :xml => @questionnaire }
#     flash[:notice] = params.inspect
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

# Paul V. comment on create:
#   Can't validate qfounders on questionnaire if ques not created yet.
#   Is there a way to model.validate without calling model.save?
#   Well, there is model.valid

  # POST /questionnaires
  # POST /questionnaires.xml
  def create
    saveerr = nil
    @questionnaire = Questionnaire.new(params[:questionnaire])
#   @questionnaire.user_id = User.find(?)
    @questionnaire.user_id = current_user.id

    if !Qfounder.params_any?(params['qfounder'])
      saveerr = 2    # no params['qfounder']
    else
# Paul suggests: ques.save only after qfounders parsed w/ no errors
      if ! @questionnaire.save
        saveerr = 0
      else
# no save errors for questionnaire, try saving qfounders
        params['qfounder'].each { |i, fdr|
          if Qfounder.is_a_fdr?(fdr)
##          if ! @questionnaire.qfounders.create(fdr) ...
            qfdr = Qfounder.new(fdr)
            qfdr.questionnaire_id = @questionnaire.id
            if ! qfdr.save
              saveerr = 0  # saveerr = 1 or 2?
            end
          end  # if is_a_fdr?
        }
      end
    end  # if-else Qfounder.params_any

    respond_to do |format|
      if saveerr.nil?    # no errors saving questionnaire
#       format.html { redirect_to(@questionnaire, :notice => 'Accelerator Application was successfully created.') }
        format.html { redirect_to(@questionnaire) }
#       format.html { render :action => "show" }
        format.xml  { render :xml => @questionnaire, :status => :created, :location => @questionnaire }
      else
        format.html { render :action => "new" }
#       format.html { redirect_to new_questionnaire_path(@questionnaire) }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
        if saveerr == 2
          flash[:notice] = '1 error prohibited this application from being saved:  Enter at least one Founder.'
        end
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
# test qfounders before or after updating questionnaire?
      if !Qfounder.params_any?(params['qfounder'])
        saveerr = 2    # no params['qfounder']
      else

# method works okay
# set all previous qfounders into oldlist
        oldlist = []
        @questionnaire.qfounders.each do |qf|
          oldlist << qf
        end
# create/update new qfounders
        params['qfounder'].each { |i, fdr|
          if Qfounder.is_a_fdr?(fdr)
            oqf = oldlist.first
            if ! oqf.nil?   # update old founder
              if ! oqf.update_attributes(fdr)
                saveerr = 0  # saveerr = 1 or 2?
              end
              oldlist.delete(oqf)
            else            # create new founder
              qfdr = Qfounder.new(fdr)
              qfdr.questionnaire_id = @questionnaire.id
              if ! qfdr.save
                saveerr = 0  # saveerr = 1 or 2?
              end
            end
          end   # if is_a_fdr?
        }
        oldlist.each do |qf|
          qf.destroy   # delete any remaining old founders
        end
# end method

      end  # if-else Qfounder.params_any
    end

    respond_to do |format|
      if saveerr.nil?    # no errors saving questionnaire
#       format.html { redirect_to(@questionnaire, :notice => 'Application was successfully updated.') }
#       format.html { redirect_to(apply_questionnaire_path(@questionnaire)) }
        format.html { render :action => "show" }
        format.xml  { head :ok }
      else
#       format.html { redirect_to :back }
        format.html { redirect_to edit_questionnaire_path(@questionnaire) }
#       format.html { render :action => "edit" }

        if saveerr == 2
          flash[:notice] = '1 error prohibited this application from being saved:  Enter at least one Founder.'
        end
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
      end
    end

  end


  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.xml
  def destroy
    @questionnaire = Questionnaire.find(params[:id])
    @questionnaire.destroy
# also destroys qfounders

# flips to index.html, should flip to new.html?
    respond_to do |format|
#     format.html { redirect_to(questionnaires_url) }
#     format.html { redirect_to new_questionnaire_path }
      format.html { redirect_to accelerators_path }
      format.xml  { head :ok }
    end
#   flash[:notice] = "try destroy questionnaire"
  end
end
