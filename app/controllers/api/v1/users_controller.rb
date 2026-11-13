module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!
      before_action :set_user, only: [:show, :update, :reputation]

      # GET /api/v1/users/:id
      def show
        render json: UserSerializer.new(@user).as_json
      end

      # PUT /api/v1/users/:id
      def update
        render_forbidden and return unless @user.id == current_user.id

        if @user.update(user_params)
          render json: UserSerializer.new(@user).as_json
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/users/:id/reputation
      def reputation
        render json: {
          reputation_score: @user.reputation_score,
          total_reviews: @user.total_reviews,
          eligible_to_adopt: @user.eligible_to_adopt?
        }
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.permit(:name, :phone)
      end
    end
  end
end
