class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
  rescue_from JsonWebToken::DecodeError, with: :render_unauthorized
  rescue_from AASM::InvalidTransition, with: :render_invalid_transition

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    return render_unauthorized("Token não fornecido") if token.blank?

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id])

    render_unauthorized("Usuário não encontrado") unless @current_user
  end

  def current_user
    @current_user
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_unauthorized(message = "Não autorizado")
    render json: { error: message }, status: :unauthorized
  end

  def render_invalid_transition(exception)
    render json: { error: "Transição de estado inválida: #{exception.message}" }, status: :unprocessable_entity
  end

  def render_forbidden(message = "Ação não permitida")
    render json: { error: message }, status: :forbidden
  end

  def paginate(scope)
    scope.page(params[:page]).per(params[:per_page] || 20)
  end
end
