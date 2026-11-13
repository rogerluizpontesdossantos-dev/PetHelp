module Api
  module V1
    class AdoptionRequestsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_adoption_request, only: [:show, :accept, :reject, :cancel, :complete]

      # GET /api/v1/adoption_requests
      def index
        requests = AdoptionRequest.where(adopter_id: current_user.id)
                                   .or(AdoptionRequest.joins(:pet).where(pets: { owner_id: current_user.id }))
                                   .order(created_at: :desc)

        requests = paginate(requests)

        render json: requests.map { |r| AdoptionRequestSerializer.new(r).as_json }
      end

      # GET /api/v1/adoption_requests/:id
      def show
        authorize_participant!
        render json: AdoptionRequestSerializer.new(@adoption_request).as_json
      end

      # POST /api/v1/adoption_requests
      def create
        pet = Pet.find(params[:pet_id])
        request = current_user.adoption_requests.new(pet: pet, message: params[:message])

        if request.save
          render json: AdoptionRequestSerializer.new(request).as_json, status: :created
        else
          render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/adoption_requests/:id/accept
      def accept
        authorize_pet_owner!
        transition!(:accept!)
      end

      # POST /api/v1/adoption_requests/:id/reject
      def reject
        authorize_pet_owner!
        transition!(:reject!)
      end

      # POST /api/v1/adoption_requests/:id/cancel
      def cancel
        authorize_participant!
        transition!(:cancel!)
      end

      # POST /api/v1/adoption_requests/:id/complete
      # Finaliza a adoção (requer termo assinado). Endpoint adicionado além do
      # que constava no plano original, pois é necessário para fechar o fluxo
      # ponta a ponta descrito na seção 4.1 (finalize_adoption).
      def complete
        authorize_pet_owner!
        transition!(:complete!)
      end

      private

      def set_adoption_request
        @adoption_request = AdoptionRequest.find(params[:id])
      end

      def authorize_participant!
        allowed = @adoption_request.adopter_id == current_user.id || @adoption_request.pet.owner_id == current_user.id
        render_forbidden unless allowed
      end

      def authorize_pet_owner!
        render_forbidden("Apenas o responsável pelo pet pode realizar esta ação") unless @adoption_request.pet.owner_id == current_user.id
      end

      def transition!(event)
        @adoption_request.public_send(event)
        render json: AdoptionRequestSerializer.new(@adoption_request).as_json
      end
    end
  end
end
