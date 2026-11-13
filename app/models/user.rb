class User < ApplicationRecord
  has_secure_password

  has_many :pets, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner
  has_many :adoption_requests, foreign_key: :adopter_id, dependent: :destroy, inverse_of: :adopter
  has_many :follow_ups, dependent: :destroy
  has_many :reviews_written, class_name: "Review", foreign_key: :reviewer_id, dependent: :destroy, inverse_of: :reviewer
  has_many :reviews_received, class_name: "Review", foreign_key: :reviewee_id, dependent: :destroy, inverse_of: :reviewee

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :cpf, presence: true, uniqueness: true,
            format: { with: /\A\d{11}\z/, message: "deve conter exatamente 11 dígitos" }
  validate :cpf_must_be_valid

  before_save :downcase_email
  before_validation :strip_cpf_formatting

  MIN_REPUTATION_TO_ADOPT = 2.0

  def total_reviews
    reviews_count
  end

  # Regra de negócio simples de elegibilidade: usuários novos (sem reviews)
  # são elegíveis; usuários com histórico precisam de reputação mínima.
  def eligible_to_adopt?
    total_reviews.zero? || reputation_score >= MIN_REPUTATION_TO_ADOPT
  end

  private

  def downcase_email
    self.email = email.downcase.strip
  end

  def strip_cpf_formatting
    self.cpf = cpf.to_s.gsub(/\D/, "") if cpf.present?
  end

  # Algoritmo padrão de validação de dígito verificador de CPF
  # (item 5.1 "Adicionar validação de CPF real" do plano).
  def cpf_must_be_valid
    return if cpf.blank? || errors[:cpf].any?

    digits = cpf.chars.map(&:to_i)

    if digits.uniq.size == 1
      errors.add(:cpf, "inválido")
      return
    end

    two_digit_check = ->(base_digits) {
      sum = base_digits.each_with_index.sum { |d, i| d * (base_digits.size + 1 - i) }
      remainder = (sum * 10) % 11
      remainder == 10 ? 0 : remainder
    }

    first_check = two_digit_check.call(digits[0..8])
    second_check = two_digit_check.call(digits[0..9])

    unless digits[9] == first_check && digits[10] == second_check
      errors.add(:cpf, "inválido")
    end
  end
end
