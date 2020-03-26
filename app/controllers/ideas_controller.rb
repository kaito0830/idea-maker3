class IdeasController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  def index
    require 'net/http'
    require 'json'

    @url = 'http://weather.livedoor.com/forecast/webservice/json/v1?city=270000'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)

    @city_telop = @output['forecasts'][0]['telop']

    @ideas = Idea.all
    @all_ranks = Idea.find(Like.group(:idea_id).order('count(idea_id) desc').limit(10).pluck(:idea_id))
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.create(idea_params)
    redirect_to ideas_path
  end

  def destroy
    idea = Idea.find(params[:id])
    idea.destroy
  end

  def show
    @idea = Idea.find(params[:id])
    @like = Like.new
    @comment = Comment.new
    @comments = @idea.comments.includes(:user)
  end

  def search
    @ideas = Idea.search(params[:keyword])
    respond_to do |format|
      format.html
      format.json
    end
  end

  private  
  def idea_params
    params.require(:idea).permit(:title, :info, :price).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end
