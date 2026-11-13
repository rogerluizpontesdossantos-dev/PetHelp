# db/seeds.rb
# Popula o banco com um fluxo completo de exemplo: doador, adotante, pet,
# solicitação aceita, termo assinado, adoção concluída e follow-ups agendados.

puts "Limpando dados existentes..."
[Review, FollowUp, AdoptionTerm, AdoptionRequest, Pet, User].each(&:delete_all)

puts "Criando usuários..."
owner = User.create!(
  name: "Maria Silva",
  email: "maria@example.com",
  cpf: "52998224725",
  phone: "11999990000",
  password: "senha123456"
)

adopter = User.create!(
  name: "João Souza",
  email: "joao@example.com",
  cpf: "11144477735",
  phone: "11988880000",
  password: "senha123456"
)

puts "Criando pets..."
pet = Pet.create!(
  owner: owner,
  name: "Rex",
  species: "dog",
  size: "medium",
  description: "Cachorro dócil, castrado e vacinado.",
  city: "São Paulo",
  state: "SP",
  vaccination_status: true
)

Pet.create!(
  owner: owner,
  name: "Mimi",
  species: "cat",
  size: "small",
  description: "Gata calma, ótima com crianças.",
  city: "São Paulo",
  state: "SP",
  vaccination_status: true
)

puts "Criando fluxo completo de adoção..."
adoption_request = adopter.adoption_requests.create!(
  pet: pet,
  message: "Tenho experiência com cães e quintal grande."
)

adoption_request.accept!

term = adoption_request.build_adoption_term(
  content: "Termo de responsabilidade de adoção do pet Rex, assumido por João Souza."
)
term.save!
term.sign

adoption_request.complete!

puts "Seed concluído: #{User.count} usuários, #{Pet.count} pets, " \
     "#{AdoptionRequest.count} solicitações, #{FollowUp.count} follow-ups agendados."
