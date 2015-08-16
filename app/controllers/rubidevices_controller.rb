class RubidevicesController < ApplicationController
  before_action :set_rubidevice, only: [:show, :edit, :update, :destroy]

  # GET /rubidevices
  # GET /rubidevices.json
  def index
    @rubidevices = Rubidevice.accessible_by(current_ability)
  end

  # GET /rubidevices/1
  # GET /rubidevices/1.json
  def show
    @rubidevice = Rubidevice.find(params[:id])
   # authorize! :show, @rubidevice
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render :json => @track.to_json(:methods => [:polyline],:only => [:name])}
      #format.json { render json: { "language" => @languages.as_json(:root => false) }.to_json }
      #              render :json => @track.to_json(:methods => [:polyline],:only => [:name])
    end
  end

  # GET /rubidevices/new
  def new
    @rubidevice = Rubidevice.new
  end

  # GET /rubidevices/1/edit
  def edit
      @rubidevice  = Rubidevice.find(params[:id])
  end

  # POST /rubidevices
  # POST /rubidevices.json
  def create
   @rubidevice = Rubidevice.new(rubidevice_params)
   @rubidevice.user = current_user 
   
    respond_to do |format|
      if @rubidevice.save
        format.html { redirect_to @rubidevice, notice: 'Rubidevice was successfully created.' }
        format.json { render :show, status: :created, location: @rubidevice }
      else
        format.html { render :new }
        format.json { render json: @rubidevice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rubidevices/1
  # PATCH/PUT /rubidevices/1.json
  def update
    respond_to do |format|
      if @rubidevice.update(rubidevice_params)
        format.html { redirect_to @rubidevice, notice: 'Rubidevice was successfully updated.' }
        format.json { render :show, status: :ok, location: @rubidevice }
      else
        format.html { render :edit }
        format.json { render json: @rubidevice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rubidevices/1
  # DELETE /rubidevices/1.json
  def destroy
    @rubidevice.destroy
    respond_to do |format|
      format.html { redirect_to rubidevices_url, notice: 'Rubidevice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rubidevice
      @rubidevice = Rubidevice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rubidevice_params
      params.require(:rubidevice).permit(:user_id, :identifier, :model, :creation, :owner)
    end
end
