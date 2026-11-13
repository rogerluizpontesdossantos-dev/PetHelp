class AdoptionTerm < ApplicationRecord
  belongs_to :adoption_request

  validates :content, presence: true
  validates :adoption_request_id, uniqueness: true

  def signed?
    signed_at.present?
  end

  def sign
    return false if signed?

    update(signed_at: Time.current)
  end
end
