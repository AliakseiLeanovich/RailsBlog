class ArticlesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_user_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(:page => params[:page]).order('created_at DESC')
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)
  end

  def get_user_article
    @article = Article.find(params[:id])
    if current_user != @article.user
      redirect_to @article, alert: t('post.alert.permissions')
    end
  end

end

WillPaginate.per_page = 3