class PointsController < ApplicationController
  before_action :set_point, only: [:show, :edit, :update, :destroy]

  # GET /points
  # GET /points.json

  def index
    track = Track.find(params[:track_id])
    @points = track.points

    gon.points = track.points
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
      format.json { render :json => @points.to_json(:methods => [:latlng ] , :only => [:tiempo])}  #Entrega arrays del metodo latlng (modelo point.rb)
     #format.json { render :json => @track.to_json(:methods => [:polyline],:only => [:name])}
    end

  end

  # GET /points/1
  # GET /points/1.json
  def show
    track = Track.find(params[:track_id])
    @point = track.points.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
      format.json { render :json => @point}
    end
  end

  # GET /points/new
  def new
    track = Track.find(params[:track_id])
    @point = track.points.build

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /points/1/edit
  def edit
    track = Track.find(params[:track_id])
    @point = track.points.find(params[:id])
  end

  # Clase importada
  def import
    track = Track.find(params[:track_id])
    track.points.import(params[:file])
    redirect_to track_points_path, notice: "Datos subidos correctamente"
  end


  # POST /points
  # POST /points.json
  def create
    track = Track.find(params[:track_id])
    @point = track.points.create(point_params)

    respond_to do |format|
      if @point.save
        format.html { redirect_to ([@point.track, @point]), :notice => 'Point was successfully created.'  }
        format.json { render :show, status: :created, location: @point }
      else
        format.html { render :new }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /points/1
  # PATCH/PUT /points/1.json
  def update
    track = Track.find(params[:track_id])
    @point = track.points.find(params[:id])

    respond_to do |format|
      if @point.update(point_params)
        format.html { redirect_to ([@point.track, @point]), :notice => 'Point was successfully updated.' }
        format.json { render :show, status: :ok, location: @point }
      else
        format.html { render :edit }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /points/1
  # DELETE /points/1.json
  def destroy
    track = Track.find(params[:track_id])
    @point = track.points.find(params[:id])
    @point.destroy
    respond_to do |format|
      format.html { redirect_to (track_points_url), :notice => 'Point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_point
      track = Track.find(params[:track_id])
      @point = Point.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def point_params
      track = Track.find(params[:track_id])
      params.require(:point).permit(:latitud, :longitud, :tiempo, :track_id)
    end
end
