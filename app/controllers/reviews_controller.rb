class ReviewsController < ApplicationController
  before_action :check_logined, except: %i(index show destroy)
  before_action :find_review, except: %i(new create)
  before_action :check_permission, only: %i(edit update destroy)
  before_action :show_action, only: %i(index show)

  def index
    @reviews = Review.order("created_at DESC").page params[:page]
  end

  def new
    @review = current_user.reviews.new
  end

  def show
    @comments = review.comments.where(parent_id: nil)
  end

  def create
    @review = current_user.reviews.new review_params
    if review.save
      flash[:success] = t(".create_successfully")
      redirect_to root_path
    else
      flash[:danger] = t(".create_fail")
      redirect_to new_review_path
    end
  end

  def edit; end

  def update
    if review.update_attributes review_params
      flash[:success] = t(".update_successfully")
      redirect_to edit_review_path(params[:id])
    else
      flash[:danger] = t(".update_fail")
      redirect_to edit_review_path(params[:id])
    end
  end

  def destroy
    if review.destroy
      flash[:success] = t ".destroy_success"
      redirect_to root_path
    else
      flash[:fail] = t ".destroy_fail"
      redirect_to edit_review_path(review)
    end
  end

  def form_reply
    @parent_comment = Comment.find_by id: params[:parent_cmt_id]
    @reply_review = Review.find_by id: params[:review_id]
    respond_to do |format|
      format.js
    end
  end

  def form_edit
    @review = Review.find_by id: params[:review_id]
    @comment = Comment.find_by id: params[:comment_id]
    respond_to do |format|
      format.js
    end
  end

  private

  attr_reader :review

  def find_review
    @review = Review.find_by id: params[:id]
  end

  def review_params
    params.require(:review).permit Review::ATTRIBUTES_PARAMS
  end

  def check_permission
    unless current_user == review.user
      flash[:danger] = t(".not_permission")
      redirect_to root_path
    end
  end

  def show_action
    @review_recent = Review.last(3)
    @brand_all = Brand.all
  end
end
