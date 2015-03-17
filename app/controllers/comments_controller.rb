class CommentsController < ApplicationController

  before_filter :authenticate_user!, only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    if @article.user == current_user
      @comment.destroy
      redirect_to article_path(@article)
    else
      redirect_to article_path(@article), alert: t('comment.label.delete_permission')
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end