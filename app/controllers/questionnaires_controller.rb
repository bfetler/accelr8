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

  # POST /questionnaires
  # POST /questionnaires.xml
  def create
    @questionnaire = Questionnaire.new(params[:questionnaire])
#   @questionnaire.user_id = User.find(?)
    @questionnaire.user_id = current_user.id

#   if !Qfounder.params_any?(params['qfounder'])
    if !params['qfounder'].nil? && params['qfounder'].any?
      params['qfounder'].each { |k, fdr|
        if Qfounder.new(fdr).valid?
          @questionnaire.qfounders.build(fdr)
        end
      }
    end  # !params['q'].nil?

    respond_to do |format|
#     @questionnaire.valid?
#     if @questionnaire.errors.empty?
      if @questionnaire.save  # also saves qfounders using build()
        format.html { redirect_to(@questionnaire) }
#       flash[:notice] = 'Accelerator Application was successfully created.'
#       format.html { render :action => "show" }
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
    @questionnaire = Questionnaire.find(params[:id])

#   oldfounders = @questionnaire.qfounders  # dynamic memory, build adds to it
    oldfounders = []
    @questionnaire.qfounders.each { |f| oldfounders << f } # not dynamic memory

#   if !Qfounder.params_any?(params['qfounder'])
    if !params['qfounder'].nil? && params['qfounder'].any?
      params['qfounder'].each { |k, fdr|
#       if Qfounder.has_params?(fdr)
        qfdr = Qfounder.new(fdr)
        if qfdr.valid?
          ffdr = qfdr.member_of(oldfounders)
          if !ffdr.nil?  # rm from oldfounders if already exists
            oldfounders.delete(ffdr)
          else  # build only if fdr params changed
            @questionnaire.qfounders.build(fdr)
          end
        end  # qfdr.valid?
      }    # params['q'].each
    end  # !params['q'].nil?

#   delete remaining oldfounders
    @questionnaire.qfounders.delete(oldfounders)

    respond_to do |format|
      if @questionnaire.update_attributes(params[:questionnaire])
#       flash[:notice] = 'Application was successfully updated.'
#       format.html { redirect_to(apply_questionnaire_path(@questionnaire)) }
        format.html { render :action => "show" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @questionnaire.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.xml
  def destroy
    @questionnaire = Questionnaire.find(params[:id])
    @questionnaire.destroy  # also destroys associated qfounders

# flips to accel index.html, should flip to ques new.html?
    respond_to do |format|
#     format.html { redirect_to new_questionnaire_path }
      format.html { redirect_to accelerators_path }
      format.xml  { head :ok }
    end
  end
end
