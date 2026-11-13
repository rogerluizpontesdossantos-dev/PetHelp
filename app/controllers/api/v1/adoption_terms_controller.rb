module Api
  module V1
    class AdoptionTermsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_adoption_term, only: [:show, :sign]

      # GET /api/v1/adoption_terms/:id
      def show
        authorize_participant!
        render json: AdoptionTermSerializer.new(@adoption_term).as_json
      end

      # POST /api/v1/adoption_terms
      def create
        adoption_request = AdoptionRequest.find(params[:adoption_request_id])

        unless adoption_request.pet.owner_id == current_user.id
          return render_forbidden("Apenas o responsável pelo pet pode criar o termo")
        end

        unless adoption_request.accepted?
          return render json: { error: "A solicitação precisa estar aceita para gerar o termo" },
                        status: :unprocessable_entity
        end

        term = adoption_request.build_adoption_term(content: params[:content])

        if term.save
          render json: AdoptionTermSerializer.new(term).as_json, status: :created
        else
          render json: { errors: term.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/adoption_terms/:id/sign
      # Ambas as partes (doador e adotante) precisam assinar antes da conclusão;
      # aqui o adotante confirma sua assinatura no termo único do fluxo.
      def sign
        authorize_participant!

        if @adoption_term.sign
          render json: AdoptionTermSerializer.new(@adoption_term).as_json
        else
          render json: { error: "Termo já assinado anteriormente" }, status: :unprocessable_entity
        end
      end

      private

      def set_adoption_term
        @adoption_term = AdoptionTerm.find(params[:id])
      end

      def authorize_participant!
        request = @adoption_term.adoption_request
        allowed = request.adopter_id == current_user.id || request.pet.owner_id == current_user.id
        render_forbidden unless allowed
      end
    end
  end
end
