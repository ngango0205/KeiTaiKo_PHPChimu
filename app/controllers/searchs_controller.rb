class SearchsController < ApplicationController
  def search
    if params[:q].present?
      @users = User.search params[:q]
      @reviews = Review.search params[:q]
    else
      @users = []
      @reviews = []
    end
  end
end
