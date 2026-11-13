module Api
  module V1
    class PetsController < ApplicationController
      before_action :authenticate_request!, except: [:index, :show]
      before_action :set_pet, only: [:show, :update, :destroy, :mark_adopted]
      before_action :authorize_owner!, only: [:update, :destroy, :mark_adopted]

      # GET /api/v1/pets
      def index
        pets = Pet.available_for_adoption
                  .by_city(params[:city])
                  .by_species(params[:species])
                  .order(created_at: :desc)

        pets = paginate(pets)

        render json: {
          pets: pets.map { |pet| PetSerializer.new(pet).as_json },
          meta: pagination_meta(pets)
        }
      end

      # GET /api/v1/pets/:id
      def show
        render json: PetSerializer.new(@pet).as_json
      end

      # POST /api/v1/pets
      def create
        pet = current_user.pets.new(pet_params)

        if pet.save
          render json: PetSerializer.new(pet).as_json, status: :created
        else
          render json: { errors: pet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/pets/:id
      def update
        if @pet.update(pet_params)
          render json: PetSerializer.new(@pet).as_json
        else
          render json: { errors: @pet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/pets/:id
      def destroy
        @pet.destroy
        head :no_content
      end

      # POST /api/v1/pets/:id/mark_adopted
      def mark_adopted
        if @pet.may_mark_adopted?
          @pet.mark_adopted!
          render json: PetSerializer.new(@pet).as_json
        else
          render json: { error: "Pet não pode ser marcado como adotado no estado atual (#{@pet.status})" },
                 status: :unprocessable_entity
        end
      end

      private

      def set_pet
        @pet = Pet.find(params[:id])
      end

      def authorize_owner!
        render_forbidden("Apenas o responsável pelo pet pode realizar esta ação") unless @pet.owner_id == current_user.id
      end

      def pet_params
        params.permit(:name, :species, :size, :description, :city, :state, :vaccination_status, :photo)
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
