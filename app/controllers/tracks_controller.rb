class TracksController < ApplicationController
  before_action :set_track, only: [:show, :edit, :update, :destroy]

 
  # GET /tracks
  # GET /tracks.json
  def index
    @tracks = Track.all
    #authorize! :read, @tracks
    gon.user_number = current_user.id

     respond_to do |format|
      format.html # show.html.erb
            format.json { render :json => @tracks.to_json(:methods => [:props], :only => [:props])}
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])
    authorize! :show, @track
    gon.track_number = Track.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @track.to_json(:methods => [:polyline],:only => [:name])}
      #format.json { render json: { "language" => @languages.as_json(:root => false) }.to_json }
      #              render :json => @track.to_json(:methods => [:polyline],:only => [:name])
    end
  end

  # GET /tracks/new
  def new
    @track = Track.new
  end

  # GET /tracks/1/edit
  def edit
    @task = Track.find(params[:id])
    authorize! :edit, @task
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(track_params)
    @track.user = current_user
    authorize! :create, @track

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render :show, status: :created, location: @track }
      else
        format.html { render :new }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracks/1
  # PATCH/PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])
    authorize! :update, @track
    respond_to do |format|
      if @track.update(track_params)
        format.html { redirect_to tracks_url, notice: 'Track was successfully updated.' }
        format.json { render :show, status: :ok, location: @track }
      else
        format.html { render :edit }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track.user = current_user
    authorize! :destroy, @track    
    @track.destroy
    authorize! :destroy, @track
    respond_to do |format|
      format.html { redirect_to tracks_url, notice: 'Track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end









  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:name, :fecha)
    end
end
