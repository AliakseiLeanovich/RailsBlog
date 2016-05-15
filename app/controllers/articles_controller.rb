class ArticlesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_user_article, only: [:edit, :update, :destroy]

  def index
    redirect_to root_path, alert: t('post.alert.no_role_permission') if !current_user.permissions[:read]
    user_articles = Article.where(id: current_user.article_ids)
    if params[:user_id]
      @articles = user_articles.where(:user_id => params[:user_id])
    elsif params[:tag]
      @articles = user_articles.tagged_with(params[:tag])
    else
      @articles = user_articles
    end
    if @articles.empty? || @articles.nil?
      redirect_to root_path, alert: t('post.alert.no_group_permission')
    end
    @articles = @articles.paginate(:page => params[:page]).order('created_at DESC')

  end

  def new
    redirect_to root_path, alert: t('post.alert.no_role_permission') if !current_user.permissions[:create]
    @article = Article.new
  end

  def create
    redirect_to root_path, alert: t('post.alert.no_role_permission') if !current_user.permissions[:create]
    @article = current_user.articles.new(article_params)
    @article.groups = current_user.groups

    if verify_recaptcha(model: @article) && @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def show
    @article = Article.find(params[:id])
    if @article.nil? || (current_user.groups&@article.groups).nil?
      redirect_to root_path, alert: t('post.alert.no_group_permission')
    end
    if !current_user.permissions[:read]
      redirect_to root_path, alert: t('post.alert.no_role_permission')
    end
  end

  def edit
    redirect_to root_path, alert: t('post.alert.no_role_permission') if !current_user.permissions[:update]
  end

  def update
    redirect_to root_path, alert: t('post.alert.no_role_permission') if !current_user.permissions[:update]
    if verify_recaptcha(model: @article) && @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    if current_user.permissions[:delete]
      @article.destroy
      @article.groups.clear
      redirect_to articles_path
    else
      redirect_to root_path, alert: t('post.alert.no_role_permission')
    end
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
    params.require(:article).permit(:title, :text, :user_id, :tag_list)
  end

  def get_user_article
    @article = Article.find(params[:id])
    if @article.nil? || (current_user.groups&@article.groups).nil?
      redirect_to root_path, alert: t('post.alert.no_group_permission')
    end
    if current_user != @article.user
      redirect_to @article, alert: t('post.alert.permissions')
    end
  end

end

WillPaginate.per_page = 5