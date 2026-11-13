class PetSerializer
  def initialize(pet)
    @pet = pet
  end

  def as_json(*)
    {
      id: pet.id,
      name: pet.name,
      species: pet.species,
      size: pet.size,
      description: pet.description,
      city: pet.city,
      state: pet.state,
      status: pet.status,
      vaccination_status: pet.vaccination_status,
      photo_url: pet.photo.attached? ? Rails.application.routes.url_helpers.rails_blob_path(pet.photo, only_path: true) : nil,
      owner: { id: pet.owner_id, name: pet.owner.name },
      created_at: pet.created_at
    }
  end

  private

  attr_reader :pet
end
