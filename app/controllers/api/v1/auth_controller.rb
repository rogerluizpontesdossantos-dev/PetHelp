module Api
  module V1
    class AuthController < ApplicationController
      # POST /api/v1/auth/register
      def register
        user = User.new(user_params)

        if user.save
          render json: { token: issue_token(user), user: UserSerializer.new(user).as_json },
                 status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email]&.downcase&.strip)

        if user&.authenticate(params[:password])
          render json: { token: issue_token(user), user: UserSerializer.new(user).as_json }
        else
          render_unauthorized("Email ou senha inválidos")
        end
      end

      private

      def issue_token(user)
        JsonWebToken.encode(user_id: user.id)
      end

      def user_params
        params.permit(:name, :email, :cpf, :phone, :password, :password_confirmation)
      end
    end
  end
end
