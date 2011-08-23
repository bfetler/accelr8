class AcceleratorsController < ApplicationController
  before_filter :authenticate_accelerator_user!, :except => [:index, :setsortorder]
# before_filter is_admin?

  # GET /accelerators
  # GET /accelerators.xml
  def index
    make_location_lists()

    if ! params[:column].nil?
      self.setsortorder()      # sort columns by param
    else
      flash[:sortcolumn] = "startdate"  # default sort by startdate
      flash[:sortorder] = "ASC"
    end
    @accelerators = Accelerator.where("izzaproved = ?", "yEs").order(flash[:sortcolumn]+" "+flash[:sortorder])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accelerators }
    end
  end

  def make_location_lists
    accelerators = Accelerator.all
    country_list = []
    accelerators.each do |a|
      insert_non_duplicate(a.country, a.id, country_list)
    end
    country_list = country_list.sort
    country_list.insert(0, ['All', 0])
    @country_list = country_list

    state_list = []
    accelerators.each do |a|
      insert_non_duplicate(a.state, a.id, state_list)
    end
    state_list = state_list.sort
    state_list.insert(0, ['All', 0])
    @state_list = state_list
# state_list should change depending on country selection

    city_list = []
    accelerators.each do |a|
      insert_non_duplicate(a.city, a.id, city_list)
    end
    city_list = city_list.sort
    city_list.insert(0, ['All', 0])
    @city_list = city_list
# city_list should change depending on state and country selection
  end

# utility to insert non-duplicate entries into list
  def insert_non_duplicate(val, id, list)
    found = nil
    list.each do |c|
      if (found.nil? && (c[0] == val))
        found = 0
      end
    end
    if found.nil? && !val.empty?
      list << [val, id]
    end
  end

# utility to set column sort order by param
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
