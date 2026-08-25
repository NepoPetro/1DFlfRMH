# Análise Inicial

## Estrutura do Projeto

- backend/src/index.js
- infrastructure/docker-compose.yml
- evidencias/vivianne/docs

## Fluxo de Cadastro

Usuário → /auth/register → API → bcrypt → PostgreSQL

## Banco de Dados

- PostgreSQL
- Tabela users
- Campo password_hash

## Observabilidade

Ainda não identificada no código.

# Descobertas do Código

## Endpoint

POST /auth/register

## Validações

- Email obrigatório
- Password obrigatória

## Segurança

- bcrypt.hashSync(password, 10)

## Banco

INSERT INTO users (email, password_hash)

## Tratamento de Erro

- 23505 = email já cadastrado
- 500 = erro interno

# Descobertas da Infraestrutura

## Banco

- PostgreSQL 15
- auth_db

## Administração do Banco

- PgAdmin

## Banco Configurado

- auth_db

## Aplicação

- Node.js
- Porta 3000

## Containers Docker
 
- db
- pgadmin
- app