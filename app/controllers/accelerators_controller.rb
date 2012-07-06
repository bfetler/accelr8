class AcceleratorsController < ApplicationController
  before_filter :authenticate_user!, :except => [:home]
  before_filter :authenticate_accelerator_user!, :except => [:index, :home]
# before_filter is_admin?

  # GET /accelerators
  # GET /accelerators.xml
  def index

    @sortcolumn = params[:column] ||= "startdate"
    @sortorder = params[:order] ||= "ASC"
    # sort columns by param
    @accelerators = Accelerator.where("izzaproved = ?", "yEs").order(@sortcolumn+" "+@sortorder)
    @userquest = Questionnaire.where(["user_id = ?", current_user]).last
#   @userquest is nil if Questionnaire not yet created for this user
#   what if no Questionnaire, Questionnaire.all = [] ?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accelerators }
    end
  end

  def home
    if user_signed_in?
      redirect_to accelerators_path
    else
      render :layout => false
    end
  end

  # GET /accelerators/1
  # GET /accelerators/1.xml
  def show
    @accelerator = Accelerator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accelerator }
    end
  end

  # GET /accelerators/1
  # GET /accelerators/1.xml
  def terms
    respond_to do |format|
      format.html # terms.html.erb
      format.xml  { head :ok }
    end
  end

  # GET /accelerators/new
  # GET /accelerators/new.xml
  def new
    @accelerator = Accelerator.new
    if accelerator_user_signed_in?
      @accelerator.email = current_accelerator_user.email
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accelerator }
    end
  end

  # GET /accelerators/1/edit
  def edit
    @accelerator = Accelerator.find(params[:id])
    if @accelerator.accelerator_user_id != current_accelerator_user.id
# cannot edit
      respond_to do |format|
        format.html { redirect_to accelerators_path }
#       format.html { redirect_to :back }
        format.xml  { head :ok }
      end
    end
  end

  # POST /accelerators
  # POST /accelerators.xml
  def create
    @accelerator = Accelerator.new(params[:accelerator])
    if accelerator_user_signed_in?
      @accelerator.accelerator_user_id = current_accelerator_user.id
      @accelerator.izzaproved = "yEs"
#   else if is_admin?
    end
# eventually admin will set izzaproved, default will be "nO"
# misspelled words more difficult for a hacker to find?
# izzaproved should not be visible from views

    respond_to do |format|
      if @accelerator.save
#       format.html { redirect_to(@accelerator, :notice => 'Accelerator was successfully created.') }
        format.html { redirect_to(accelerators_path, :notice => 'Accelerator was successfully created.') }
        format.xml  { render :xml => @accelerator, :status => :created, :location => @accelerator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accelerator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accelerators/1
  # PUT /accelerators/1.xml
  def update
    @accelerator = Accelerator.find(params[:id])

    did_update = nil
    if @accelerator.accelerator_user_id == current_accelerator_user.id
#   or is_admin?
# can update
      if @accelerator.update_attributes(params[:accelerator])
        did_update = :true
      end
    end

    respond_to do |format|
      if did_update == :true
#       format.html { redirect_to(@accelerator, :notice => 'Accelerator was successfully updated.') }
        format.html { redirect_to(accelerators_path, :notice => 'Accelerator was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accelerator.errors, :status => :unprocessable_entity }
      end
    end
#   flash[:notice] = "accel update: " + params.inspect
  end

  # DELETE /accelerators/1
  # DELETE /accelerators/1.xml
  def destroy
    @accelerator = Accelerator.find(params[:id])

    respond_to do |format|
      if @accelerator.accelerator_user_id != current_accelerator_user.id
#   or is_admin?
# cannot destroy
#       format.html { redirect_to accelerators_path }
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        @accelerator.destroy
        format.html { redirect_to(accelerators_url) }
#       format.html # index.html.erb
#       format.html { render :action => "index" }
        format.xml  { head :ok }
      end
    end
  end
end
