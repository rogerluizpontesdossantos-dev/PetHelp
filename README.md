# PetHelp — Backend (MVP)

Plataforma de adoção responsável de pets com acompanhamento pós-adoção
estruturado (follow-ups em 7/30/90 dias) e reputação bidirecional.

## Status honesto deste código

Este é código Ruby real, gerado a partir de `Plano_PetHelp.txt`. Ele **não foi
executado** neste ambiente (sem acesso a rubygems.org / PostgreSQL / Redis
aqui), então trate como "primeira versão para revisão", não como testado em
produção. Antes de considerar o MVP pronto, rode localmente os passos abaixo
e corrija o que aparecer.

## Rodando localmente

```bash
bundle install
cp .env.example .env   # preencha SECRET_KEY_BASE, DATABASE_URL, REDIS_URL
export $(cat .env | xargs)   # ou use dotenv-rails (já está no Gemfile)

rails db:create
rails db:migrate
rails db:seed

rails server          # API em http://localhost:3000
bundle exec sidekiq   # em outro terminal, para os jobs de follow-up
```

## Testes

```bash
bundle exec rspec
```

## Decisões tomadas que não estavam 100% explícitas no plano

- **Endpoint `POST /adoption_requests/:id/complete`**: o plano listava o evento
  `complete` na state machine, mas não uma rota HTTP para acioná-lo. Adicionei
  para fechar o fluxo ponta a ponta (aceitar → assinar termo → concluir).
- **Autorização**: feita inline nos controllers (`authorize_owner!` /
  `authorize_participant!`) em vez de Pundit/CanCanCan, para manter o MVP
  simples. Pundit está listado como gem "recomendada" no plano se quiserem
  evoluir para policies formais.
- **Serializers**: classes Ruby simples (`as_json`), sem a gem
  `active_model_serializers`, que não estava no Gemfile do plano.
- **Elegibilidade de adoção** (`User#eligible_to_adopt?`): o plano cita o
  método mas não a regra exata. Implementei: usuários sem histórico de
  reviews são elegíveis; usuários com histórico precisam de reputação ≥ 2.0.
  Isso é uma escolha razoável, não uma especificação do documento — ajustem
  se tiverem um critério de negócio diferente.
- **Validação de CPF**: implementado o algoritmo real de dígito verificador
  (item 5.1 do plano), não apenas checagem de 11 dígitos.

## O que ainda falta (do próprio roadmap do plano, seções 5–10)

Upload real de imagens (S3), envio de emails/push, chat, busca avançada,
mapa, rate limiting, dashboard admin, documentação Swagger, CI/CD, deploy.
