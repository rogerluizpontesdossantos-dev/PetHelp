# app/lib/json_web_token.rb
#
# Responsável por codificar e decodificar tokens JWT usados na autenticação
# stateless da API. Expiração padrão: 30 dias (conforme Plano_PetHelp.txt, item 4.2).

class JsonWebToken
  ALGORITHM = "HS256".freeze

  class DecodeError < StandardError; end

  def self.secret_key
    Rails.application.credentials.secret_key_base || ENV.fetch("SECRET_KEY_BASE")
  end

  def self.encode(payload, exp = 30.days.from_now)
    payload = payload.dup
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    raise DecodeError, "Token expirado"
  rescue JWT::DecodeError
    raise DecodeError, "Token inválido"
  end
end
