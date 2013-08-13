require 'spec_helper'

describe MoviesController do
  describe "add director" do
    before :each do
      @fake_movie1=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@fake_movie1)
    end
    it 'should call update_attributes and redirect' do
      @fake_movie1.stub!(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @fake_movie1}
      response.should redirect_to(movie_path(@fake_movie1))
    end


  end

  describe "basic operations" do
    it 'should show a movie detail' do
      Movie.should_receive(:find).with("1").and_return(@fake_movie1)
      get :show, {:id => "1"}
      response.should render_template(:show)
    end
    it 'should list the movies' do
      Movie.should_receive(:find).with("1").and_return(@fake_movie1)
      get :show, {:id => "1"}
      response.should render_template(:show)
    end
    it 'should create a new movie' do
      get :new
      response.should render_template(:new)
    end
    it 'should list the movies' do
      get :index
      response.should render_template(:index)
    end
    it 'should sort the movie list' do
      get :index, {:sort => "title"}

      session[:sort].blank?.should == false
    end
    it 'should return the allowed ratings' do
      @fake_movie1 = mock(Movie, :title => "Movie 1", :director => "director", :id => "1")
      @fake_movie2 = mock(Movie, :title => "Movie 2", :director => "director", :id => "2")
      @fake_movies = [@fake_movie1, @fake_movie2]
      Movie.stub!(:find_all_by_rating).with(["PG-13"]).and_return(@fake_movies)
      get :index, {:ratings => ["PG-13"]}

      session[:ratings].blank?.should == false
    end
    #it 'should save the new movie' do
    #  Movie.stub!(:create).with(@fake_movie1)
    #
    #  post :create, {:movie => @fake_movie1}
    #  response.should redirect_to(movie_path(@fake_movie1))
    #end
    it 'should allow to edit a movie' do
      Movie.stub!(:find).with("1").and_return(@fake_movie1)
      get :edit, {:id => "1"}
      response.should render_template(:edit)
    end
    it 'should delete a movie' do
      Movie.should_receive(:find).with("1").and_return(@fake_movie1)
      @fake_movie1.should_receive(:destroy)

      delete :destroy, {:id => "1"}
      response.should redirect_to(movies_path)
    end
  end




  describe "searching for movies by director"
    before :each do
      @fake_movie1 = mock(Movie, :title => "Movie 1", :director => "director", :id => "1")
      @fake_movie2 = mock(Movie, :title => "Movie 2", :director => "director", :id => "2")
      @fake_movie3 = mock(Movie, :title => "Movie 3", :director => nil, :id => "3")
      @fake_movies = [@fake_movie1, @fake_movie2]

      #Movie.stub!(:find_all_by_director).with('director').and_return(@fake_movies)
    end

    it "should find movies with same director" do
      Movie.should_receive(:find).with("1").and_return(@fake_movie1)
      Movie.should_receive(:find_all_by_director).with('director').and_return(@fake_movies)

      get :similar_movies, {:id => "1"}
      response.should render_template(:similar_movies)
    end

    it "should redirect to homepage when not match is found" do
      Movie.should_receive(:find).with("3").and_return(@fake_movie3)

      get :similar_movies, {:id => "3"}
      response.should redirect_to(movies_path)
    end
end