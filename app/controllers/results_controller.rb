class ResultsController < ApplicationController
  def index
    @search_results = Article.search_everywhere(params[:query])
  end
end
