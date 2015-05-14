class ResultsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @search_results = Article.search_everywhere(params[:query])
  end
end
