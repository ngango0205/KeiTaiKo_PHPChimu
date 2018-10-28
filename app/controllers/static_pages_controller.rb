class StaticPagesController < ApplicationController
  def show
    @brands = Brand.last(10)
    @recent_reviews = Review.last(4)
    
    @users = User.all.sort { |a, b| a.reviews.count <=> b.reviews.count }
    @most_review_users = @users.reverse.first(4)

    @brands = Brand.all.sort { |a, b| a.reviews.count <=> b.reviews.count }
    @most_popular_brands = @brands.reverse.first(4)
  end
end
