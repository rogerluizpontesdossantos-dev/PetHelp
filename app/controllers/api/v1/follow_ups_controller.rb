module Api
  module V1
    class FollowUpsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_follow_up, only: [:show, :update]

      # GET /api/v1/follow_ups
      def index
        follow_ups = current_user.follow_ups.order(due_date: :asc)
        follow_ups = follow_ups.where(status: params[:status]) if params[:status].present?

        render json: follow_ups.map { |f| FollowUpSerializer.new(f).as_json }
      end

      # GET /api/v1/follow_ups/:id
      def show
        authorize_owner!
        render json: FollowUpSerializer.new(@follow_up).as_json
      end

      # POST /api/v1/follow_ups
      # Uso administrativo/manual; o fluxo normal é criado pelo FollowUpScheduler.
      def create
        follow_up = FollowUp.new(follow_up_create_params)

        if follow_up.save
          render json: FollowUpSerializer.new(follow_up).as_json, status: :created
        else
          render json: { errors: follow_up.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/follow_ups/:id
      # Responder ao acompanhamento pós-adoção.
      def update
        authorize_owner!

        @follow_up.answer!(
          well_being_rating: params[:well_being_rating],
          notes: params[:notes]
        )
        render json: FollowUpSerializer.new(@follow_up).as_json
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def set_follow_up
        @follow_up = FollowUp.find(params[:id])
      end

      def authorize_owner!
        render_forbidden unless @follow_up.user_id == current_user.id
      end

      def follow_up_create_params
        params.permit(:user_id, :pet_id, :milestone, :due_date)
      end
    end
  end
end
