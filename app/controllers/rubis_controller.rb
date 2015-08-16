class RubisController < ApplicationController
  before_action :set_rubi, only: [:show, :edit, :update, :destroy]

  # GET /rubis
  # GET /rubis.json
  # Es el indice el que filtra los dispositivos a mostrar
  def index                         
    usuario    = current_user
    usuario_id = usuario.id
    user = User.find(usuario_id)
    @rubis = user.rubis

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @rubis.to_json(:methods => [:rubi_props], :only => [:rubi_props])}
    end
  end

  # GET /rubis/1
  # GET /rubis/1.json
  def show
    authorize! :show, @rubi

#        track = Track.find(params[:track_id])
#    @point = track.points.find(params[:id])

  end

  # GET /rubis/new
  def new
    @rubi = Rubi.new
    @rubi.user = current_user

  end

  # GET /rubis/1/edit
  def edit
        authorize! :edit, @rubi
  end

  # POST /rubis
  # POST /rubis.json
  def create
    @rubi = Rubi.new(rubi_params)
    @rubi.user = current_user


    respond_to do |format|
      if @rubi.save
        format.html { redirect_to rubis_url, notice: 'Rubi was successfully created.' }
        format.json { render :show, status: :created, location: @rubi }
      else
        format.html { render :new }
        format.json { render json: @rubi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rubis/1
  # PATCH/PUT /rubis/1.json
  def update
    respond_to do |format|
      if @rubi.update(rubi_params)
        format.html { redirect_to rubis_url, notice: 'Rubi was successfully updated.' }
        format.json { render :show, status: :ok, location: @rubi }
      else
        format.html { render :edit }
        format.json { render json: @rubi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rubis/1
  # DELETE /rubis/1.json
  def destroy
    @rubi.destroy
    respond_to do |format|
      format.html { redirect_to rubis_url, notice: 'Rubi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rubi
      @rubi = Rubi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rubi_params
      params.require(:rubi).permit(:user_id, :serie, :nombre, :identificacion)
    end
end
