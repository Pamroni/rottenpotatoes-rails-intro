class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Load all the ratings from the movie class
    @all_ratings = Movie.ratings

    #Sort problem
    @sort = params[:sort]

    #If there are params sent we filter out the ratings also
    if params[:ratings]
      #use this to keep track in the index view
      @checked_boxes = params[:ratings]
      @movies = Movie.where(rating: @checked_boxes.keys).order(@sort)
      #puts params[:ratings].keys
    else #If not just stick to the sort stuff
      #sets up the nil case
      @checked_boxes = []
      @movies = Movie.all.order(@sort)
    end
    @movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
