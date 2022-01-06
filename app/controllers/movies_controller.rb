class MoviesController < ApplicationController
  require 'rounding'

  before_action :set_movie, only: %i[ show edit update destroy schedule]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def schedule
    set_movie
    @run_time_gap = @movie.run_time.ceil_to(5) - @movie.run_time #The extra time we need between movies so they always start on a multiple of 5 minutes.
    @show_times = {} #The empty hash that we'll fill and pass to the view
    #In a full application, theater hours would have their own table and add things like holidays
    @theater_hours = {"weekday" => [11, 23], "weekend" => [10.5, 24]} 
    
    #"The last showing should end as close as possible to the end of the cinema's hours of operation", 
    #I'm working on the assumption that we don't need to add 20 minutes after the final show for cleanup.
    #Any place I've ever worked in retail pays for some time after the official closing time for those kind of duties.

    #Since there is no rule regarding how late after opening the first showing can start, 
    #we should start with the last showing and work backwards. Therefore, the last show ends exactly at closing in every theater
    #then counts backwards with 35 minutes between shows.
    #An alternative would be to divide the excess free time evenly between movies, which I may do as a separate branch.
    #This version keeps labor costs down since some employees can come in for the first show instead of right at opening.

    #Option 2 would be to stagger closing times so that a single cleaning crew can service all theaters
    #This also moves the first show of the day earlier by a like amount.
    #If possible, please follow up with customer. present current build as well as "equal spacing" and "staggered closing" options.

    @theater_hours.each do |t|
      theater_open = Time.now.beginning_of_day + t[1][0].hours
      theater_close = Time.now.beginning_of_day + t[1][1].hours
      movie_end = theater_close - @run_time_gap.minutes
      movie_start = movie_end - @movie.run_time.minutes
      show_times = [] 
      while movie_start >= (theater_open + 15.minutes) #Have to get those previews for the first movie in there 
        #creates a string with start and end times for the show and adds it to the array of shows for the day.
        show_times << movie_start.strftime("%I:%M %p").to_s + ' to ' + movie_end.strftime("%I:%M %p").to_s 
        #15 minutes of previews before the movie we just added and 20 minutes of cleaning after the one we're about to add plus the run_time gap to get a multiple of 5
        #These new start and end times are only added to show times if the movie starts 15 or more minutes after the theater opens
        movie_end = movie_start - 35.minutes  - @run_time_gap.minutes
        movie_start = movie_end - @movie.run_time.minutes 
      end
      @show_times[t[0]] = show_times.reverse #puts the show times in earliest to latest order
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:name, :rating, :run_time)
    end
end
