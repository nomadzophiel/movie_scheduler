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
    @run_time = @movie.run_time.ceil_to(5) #rounds the movie run time up to the nearest 5 using the Rounding gem
    @weekdays = [] #We'll be filling both of these with show time strings
    @weekends = []
    
    #in a more fleshed out app, these times would probably have their own database entries and we'd also iterate through each set of open-close times
    
    @weekday_open = Time.now.beginning_of_day + 11.hours
    @weekday_close = Time.now.beginning_of_day + 23.hours
    @weekend_open = Time.now.beginning_of_day + 10.hours + 30.minutes
    @weekend_close = Time.now.beginning_of_day + 24.hours

    #"The last showing should end as close as possible to the end of the cinema's hours of operation", 
    #I'm working on the assumption that we don't need to add 20 minutes after the final show for cleanup. They can do that after closing.
    #Since there is no rule regarding how late after opening the first showing can start, 
    #we should start with the last showing and work backwards. Therefore, every show ends exactly at closing.
    
    @weekday_movie_end = @weekday_close
    @weekday_movie_start = @weekday_close - @run_time.minutes 
    while @weekday_movie_start >= (@weekday_open + 15.minutes) 
      @weekdays << @weekday_movie_start.strftime("%I:%M %p").to_s + ' to ' + @weekday_movie_end.strftime("%I:%M %p").to_s #creates a string with start and end times for the show and adds it to the array of shows for the day.
      @weekday_movie_end = @weekday_movie_start - 35.minutes #15 minutes of previews before the movie we just added and 20 minutes of cleaning after the one we're about to add.
      @weekday_movie_start = @weekday_movie_end - @run_time.minutes #These new start and end times are only added if the movie starts 15 or more minutes after the theater opens
    end
    
    #and again for the weekends
    
    @weekend_movie_end = @weekend_close
    @weekend_movie_start = @weekend_close - @run_time.minutes
    while @weekend_movie_start >= (@weekend_open + 15.minutes) 
      @weekends << @weekend_movie_start.strftime("%I:%M %p").to_s + ' to ' + @weekend_movie_end.strftime("%I:%M %p").to_s
      @weekend_movie_end = @weekend_movie_start - 35.minutes
      @weekend_movie_start = @weekend_movie_end - @run_time.minutes
    end
    
    #now we have to reverse the array of entries to go from earliest to latest
    
    @weekday_movies = @weekdays.reverse
    @weekend_movies = @weekends.reverse
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
