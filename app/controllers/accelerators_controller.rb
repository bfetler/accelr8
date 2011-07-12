class AcceleratorsController < ApplicationController

  # GET /accelerators
  # GET /accelerators.xml
  def index
    if ! params[:column].nil?
      self.setsortorder()      # sort columns by param
      @accelerators = Accelerator.order(params[:column]+" "+flash[:sortorder])
    else
#     @accelerators = Accelerator.all  # sort by index
      @accelerators = Accelerator.order("name")  # sort by name
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accelerators }
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

  # GET /accelerators/new
  # GET /accelerators/new.xml
  def new
    @accelerator = Accelerator.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accelerator }
    end
  end

  # GET /accelerators/1/edit
  def edit
    @accelerator = Accelerator.find(params[:id])
  end

  # POST /accelerators
  # POST /accelerators.xml
  def create
    @accelerator = Accelerator.new(params[:accelerator])

    respond_to do |format|
      if @accelerator.save
        format.html { redirect_to(@accelerator, :notice => 'Accelerator was successfully created.') }
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

    respond_to do |format|
      if @accelerator.update_attributes(params[:accelerator])
        format.html { redirect_to(@accelerator, :notice => 'Accelerator was successfully updated.') }
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
    @accelerator.destroy

    respond_to do |format|
      format.html { redirect_to(accelerators_url) }
#     format.html # index.html.erb
#     format.html { render :action => "index" }
      format.xml  { head :ok }
    end
  end
end
