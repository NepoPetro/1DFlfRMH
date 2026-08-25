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

# Fluxo Real Encontrado

Usuário
↓
Frontend
↓
POST /auth/register
↓
Node.js / Express
↓
Validação de Email e Senha
↓
bcrypt.hashSync()
↓
INSERT INTO users
↓
PostgreSQL (auth_db)

# Arquitetura Esperada para o Diagrama

Usuário
↓
Frontend
↓
BFF
↓
API
↓
Assinatura Digital
↓
PostgreSQL
├─ users
└─ audit_logs
      ↓
Hash Encadeado

Em caso de falha
↓
DLQ

Monitoramento
↓
Prometheus
↓
Grafana

Eventos
↓
DLT
├─ Slack
└─ Compliance