class QuestionnairesController < ApplicationController
  before_filter :authenticate_user!, :except => [:setsortorder, :qfounders_params_any, :fdr_any]

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
    @questionnaire = Questionnaire.find(params[:id])

# used by accelerator/_list.html.erb
    if ! params[:column].nil?
      self.setsortorder()      # sort columns by param
    else
#     @accelerators = Accelerator.all  # sort by index
      flash[:sortcolumn] = "startdate"  # default sort by startdate
      flash[:sortorder] = "ASC"
    end
#   only show Accelerators that accept FH applications, by sort column order
#   @accelerators = Accelerator.where(:acceptapp => "Yes").order(flash[:sortcolumn]+" "+flash[:sortorder])
    @accelerators = Accelerator.order(flash[:sortcolumn]+" "+flash[:sortorder])

    respond_to do |format|
      format.html # apply.html.erb
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
#   @questionnaire.user_id = User.find(?)
    @questionnaire.user_id = current_user.id

    if qfounders_params_any(params['qfounder']) == :false
      saveerr = 2    # no params['qfounder']
    else
      if ! @questionnaire.save
        saveerr = 0
      else
# no save errors for questionnaire, try saving qfounders
        params['qfounder'].each { |i, fdr|
          if fdr_any(fdr) == :true
#           if ! @questionnaire.qfounders.create(fdr) ...
            @qfdr = Qfounder.new(fdr)
            @qfdr.questionnaire_id = @questionnaire.id
            if ! @qfdr.save
              saveerr = 0  # saveerr = 1 or 2?
            end
          end  # if fdr_any
        }
      end
    end  # if-else qfounders_params_any

    respond_to do |format|
      if saveerr.nil?    # no errors saving questionnaire
#       format.html { redirect_to(@questionnaire, :notice => 'Accelerator Application was successfully created.') }
#       format.html { redirect_to(apply_questionnaire_path(@questionnaire)) }
        format.html { render :action => "show" }
        format.xml  { render :xml => @questionnaire, :status => :created, :location => @questionnaire }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
        if saveerr == 2
          flash[:notice] = '1 error prohibited this application from being saved:  Enter at least one Founder.'
        end
      end
    end
  end

# utility methods
  def qfounders_params_any(paramq)
# usually paramq = params['qfounder']
    if ! paramq.nil?
      if paramq.any?
        paramq.each { |i, fdr|
#         if fdr_any(fdr) == :true
          fdr.each { |j, fval|
# j=='willcode', fval='' or '1'  exclude?
            if fval != ""   # check if any value is non-empty
              return :true
            end
          }
        }
      end
    end
    return :false
  end

  def fdr_any(fdr)
    fdr.each { |j, fval|
# j=='willcode', fval='' or '1'  exclude?
      if fval != ""   # check if any value is non-empty
        return :true
      end
    }
    return :false
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
      if qfounders_params_any(params['qfounder']) == :false
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
          if fdr_any(fdr) == :true
            oqf = oldlist.first
            if ! oqf.nil?   # update old founder
              if ! oqf.update_attributes(fdr)
                saveerr = 0  # saveerr = 1 or 2?
              end
              oldlist.delete(oqf)
            else            # create new founder
              @qfdr = Qfounder.new(fdr)
              @qfdr.questionnaire_id = @questionnaire.id
              if ! @qfdr.save
                saveerr = 0  # saveerr = 1 or 2?
              end
            end
          end   # if fdr_any
        }
        oldlist.each do |qf|
          qf.destroy   # delete any remaining old founders
        end
# end method

      end  # if-else qfounders_params_any
    end

    respond_to do |format|
      if saveerr.nil?    # no errors saving questionnaire
#       format.html { redirect_to(@questionnaire, :notice => 'Application was successfully updated.') }
#       format.html { redirect_to(apply_questionnaire_path(@questionnaire)) }
        format.html { render :action => "show" }
        format.xml  { head :ok }
      else
#       format.html { redirect_to :back }
#       format.html { redirect_to edit_questionnaire_path(@questionnaire) }
        format.html { render :action => "edit" }

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
