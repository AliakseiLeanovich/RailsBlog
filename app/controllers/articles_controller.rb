class ArticlesController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :get_user_article, only: [:edit, :update, :destroy]

  def index
    if params[:user_id]
      @articles = Article.where(:user_id => params[:user_id]).
                          paginate(:page => params[:page]).order('created_at DESC')
    else
      @articles = Article.paginate(:page => params[:page]).order('created_at DESC')
    end
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

  def stats
    @stats = Hash.new
    @stats[:article_count] = Article.group_by_month(:created_at).count
    @stats[:user_count] = User.group_by_month(:created_at).count
    @stats[:article_by_user] = Article.group(:user_id).count.map { |key, value|
      [User.find(key).nickname, value]
    }
    @stats[:article_by_comment] = Comment.group(:article_id).count.map { |key, value|
      article = Article.find(key)
      ["#{article.title.truncate(15, separator: ' ')}, #{User.find(article.user_id).nickname}", value]
    }
  end

  private
  def article_params
    params.require(:article).permit(:title, :text, :user_id)
  end

  def get_user_article
    @article = Article.find(params[:id])
    if current_user != @article.user
      redirect_to @article, alert: t('post.alert.permissions')
    end
  end

end

WillPaginate.per_page = 3