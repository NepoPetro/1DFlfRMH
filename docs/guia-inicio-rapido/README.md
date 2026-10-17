# Guia de Início Rápido - Projeto 1DFlfRMH

Este guia documenta os passos essenciais para configuração do ambiente de desenvolvimento local do ecossistema NepoPetro.

## 🚀 Passo 5: Levantando o Ambiente com Docker

Para iniciar os serviços do projeto, navegue até a raiz e execute o comando:
```bash
docker compose -f infrastructure/docker-compose.yml up -d
```

### 🛠️ Correção Prática de Infraestrutura
Durante a inicialização, identificou-se que o script de criação automatizada de tabelas não foi executado. Para sanar a ausência da tabela de autenticação, realizou-se a injeção manual da tabela diretamente no contêiner do banco:
```bash
docker exec -i auth-db psql -U postgres -d auth_db -c "CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, email VARCHAR(255) UNIQUE NOT NULL, password_hash VARCHAR(255) NOT NULL);"
```

---

## 🧪 Passo 6: Validação do Registro de Usuário

Com a tabela estruturada, validou-se o endpoint de cadastro simulando uma requisição de API com o comando `curl`:

```bash
curl -X POST http://localhost:3000/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email": "luiza@teste.com", "password": "senha_segura"}'
```

### 📋 Evidência de Sucesso
O banco de dados computou o registro corretamente, aplicando o hash criptográfico (`bcrypt`) na senha informada:

| id | email | password_hash |
|----|-------|---------------|
| 1 | luiza@teste.com | \$2a\$10\$Ht96/qazrb7klno3P9312ur4c0T3iRFci578/f15WMxd/nq3Gk0Iu |
