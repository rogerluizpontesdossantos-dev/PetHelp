module Api
  module V1
    class ReviewsController < ApplicationController
      before_action :authenticate_request!

      # GET /api/v1/reviews?user_id=123
      def index
        scope = params[:user_id].present? ? Review.where(reviewee_id: params[:user_id]) : Review.where(reviewer_id: current_user.id)
        reviews = paginate(scope.order(created_at: :desc))

        render json: reviews.map { |r| ReviewSerializer.new(r).as_json }
      end

      # POST /api/v1/reviews
      def create
        adoption_request = AdoptionRequest.find(params[:adoption_request_id])
        reviewee = other_party(adoption_request)

        review = current_user.reviews_written.new(
          reviewee: reviewee,
          adoption_request: adoption_request,
          rating: params[:rating],
          comment: params[:comment]
        )

        if review.save
          render json: ReviewSerializer.new(review).as_json, status: :created
        else
          render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def other_party(adoption_request)
        if adoption_request.adopter_id == current_user.id
          adoption_request.pet.owner
        else
          adoption_request.adopter
        end
      end
    end
  end
end
