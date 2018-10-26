class CommentsController < ApplicationController
  before_action :find_review, only: %i(create update destroy)
  before_action :find_comment, only: %i(update destroy)
  before_action :check_permission, only: :destroy

  def create
    if params[:comment].present?
      create_comment
    else
      create_reply_comment
    end
  end

  def update
    if comment.update_attributes comments_params
      respond_to do |format|
        format.html {
          flash[:success] = t ".update_success"
          redirect_to review
        }
        format.js
      end
    else
      respond_to do |format|
        format.html {
          flash[:danger] = t ".update_fail"
          redirect_to review
        }
        format.js {render inline: "location.reload();"}
      end
    end
  end

  def destroy
    @review = comment.review
    @sub_comment = Comment.find_sub_comments(comment.id)
    if comment.destroy && sub_comment.destroy_all
      flash[:success] = t ".delete_success"
      redirect_to review
    else
      flash[:danger] = t ".delete_fail"
      redirect_to review
    end
  end

  private

  attr_reader :comment, :review, :sub_comment, :parent_comment

  def check_permission
    unless comment.user == current_user
      flash[:danger] = t ".not_permission"
      redirect_to review
    end
  end

  def find_review
    @review = Review.find_by id: params[:review_id]
  end

  def find_comment
    @comment = Comment.find_by id: params[:id]
  end

  def comments_params
    params.require(:comment).permit Comment::ATTRIBUTES_PARAMS
  end

  def reply_comment_params
    params.require(:reply_comment).permit Comment::ATTRIBUTES_PARAMS
  end

  def create_comment
    @comment = review.comments.new comments_params
    comment.user = current_user
    if comment.save
      flash[:success] = t ".comment_success"
      redirect_to review_path(params[:review_id])
    else
      flash[:danger] = t ".comment_fail"
      redirect_to review_path(params[:review_id])
    end
  end

  def create_reply_comment
    @comment = review.comments.new reply_comment_params
    @parent_comment = Comment.find_by id: params[:parent_comment_id]
    comment.user = current_user
    comment.parent_id = parent_comment.id
    if comment.save
      respond_to do |format|
        format.html {
          flash[:success] = t ".comment_success"
          redirect_to review_path(params[:review_id])
        }
        format.js { render :action => "reply_comment" }
      end
    else
      respond_to do |format|
        format.html {
          flash[:danger] = t ".comment_fail"
          redirect_to review_path(parent_comment)
        }
        format.js {render inline: "location.reload();"}
      end
    end
  end
end
