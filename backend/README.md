# NeuroFlux Backend

[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-5.x-000000?logo=express&logoColor=white)](https://expressjs.com/)
[![Sequelize](https://img.shields.io/badge/Sequelize-6.x-52B0E7?logo=sequelize&logoColor=white)](https://sequelize.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![JWT](https://img.shields.io/badge/JWT-Auth-000000?logo=jsonwebtokens&logoColor=white)](https://jwt.io/)
[![License](https://img.shields.io/badge/License-Academic-blue)](#licença)

API REST do **NeuroFlux**, responsável pela autenticação, gerenciamento de usuários, tarefas e subtarefas do aplicativo.

**Pequenas etapas, grandes conquistas.**

> Backend acadêmico desenvolvido em **Node.js + Express**, com persistência em **MySQL**, ORM **Sequelize** e autenticação via **JWT**.

---

## Sumário

- [Sobre o backend](#sobre-o-backend)
- [Tecnologias](#tecnologias)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Passo a passo para usar o backend](#passo-a-passo-para-usar-o-backend)
- [Arquivos de configuração](#arquivos-de-configuração)
- [Banco de dados](#banco-de-dados)
- [Executando o servidor](#executando-o-servidor)
- [Endpoints da API](#endpoints-da-api)
- [Autenticação e permissões](#autenticação-e-permissões)
- [Exemplos de requisições](#exemplos-de-requisições)
- [Solução de problemas](#solução-de-problemas)
- [Contexto acadêmico](#contexto-acadêmico)
- [Licença](#licença)

---

## Sobre o backend

O backend do **NeuroFlux** é a camada responsável por processar as regras principais da aplicação e fornecer dados ao cliente Flutter por meio de uma API REST.

Ele centraliza:

- Cadastro e login de usuários;
- Geração e validação de tokens JWT;
- Controle de permissões por perfil;
- Gerenciamento de usuários;
- CRUD de tarefas;
- CRUD de subtarefas;
- Associação entre usuários, tarefas e subtarefas;
- Persistência dos dados em banco MySQL.

A comunicação com o frontend acontece via **HTTP/JSON**. Rotas protegidas exigem o envio do token no header:

```http
Authorization: Bearer <token>
```

---

## Tecnologias

| Tecnologia | Uso |
|-----------|-----|
| [Node.js](https://nodejs.org/) | Runtime JavaScript do servidor |
| [Express](https://expressjs.com/) | Framework para criação da API REST |
| [Sequelize](https://sequelize.org/) | ORM para comunicação com o banco |
| [MySQL](https://www.mysql.com/) | Banco de dados relacional |
| [mysql2](https://www.npmjs.com/package/mysql2) | Driver MySQL para Node.js |
| [bcrypt](https://www.npmjs.com/package/bcrypt) | Comparação de senha no login |
| [bcryptjs](https://www.npmjs.com/package/bcryptjs) | Hash de senhas |
| [jsonwebtoken](https://www.npmjs.com/package/jsonwebtoken) | Geração e validação de JWT |
| [dotenv](https://www.npmjs.com/package/dotenv) | Variáveis de ambiente |
| [cors](https://www.npmjs.com/package/cors) | Liberação de acesso para o frontend |
| [sequelize-cli](https://www.npmjs.com/package/sequelize-cli) | Execução de migrations |

---

## Estrutura de pastas

```text
backend/
├── config/
│   ├── database.js
│   └── config.json.example
│
├── controllers/
│   ├── UsuarioController.js
│   ├── TarefaController.js
│   └── SubtarefaController.js
│
├── middlewares/
│   ├── auth.js
│   └── authorize.js
│
├── migrations/
│
├── models/
│   ├── index.js
│   ├── usuario.js
│   ├── tarefa.js
│   └── subtarefa.js
│
├── routes/
│   ├── index.js
│   ├── usuario.routes.js
│   ├── tarefa.routes.js
│   └── subtarefas.routes.js
│
├── .env.example
├── .gitignore
├── .sequelizerc
├── package.json
├── package-lock.json
└── server.js
```

---

# Passo a passo para usar o backend

## 1. Clonar o repositório

```bash
git clone https://github.com/vasconcelosfelipe642-lang/neuroflux.git
cd neuroflux/backend
```

---

## 2. Instalar as dependências

```bash
npm install
```

---

## 3. Ajustar os arquivos de configuração

O repositório **já possui** os arquivos necessários de exemplo:

```text
backend/.env.example
backend/config/config.json.example
```

Esses arquivos já estão no projeto para facilitar a configuração do backend.

Quem for usar o projeto só precisa **abrir esses arquivos e alterar os valores de acordo com o próprio ambiente**, como usuário do MySQL, senha, nome do banco, host, porta e chave JWT.

### `.env.example`

Arquivo localizado em:

```text
backend/.env.example
```

Edite os valores conforme seu ambiente local:

```env
PORT=3000

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=sua_senha_mysql
DB_NAME=neuroflux

JWT_SECRET=sua_chave_secreta
```

### `config.json.example`

Arquivo localizado em:

```text
backend/config/config.json.example
```

Edite os valores conforme seu ambiente local:

```json
{
  "development": {
    "username": "root",
    "password": "sua_senha_mysql",
    "database": "neuroflux",
    "host": "localhost",
    "port": 3306,
    "dialect": "mysql"
  },
  "test": {
    "username": "root",
    "password": "sua_senha_mysql",
    "database": "neuroflux_test",
    "host": "localhost",
    "port": 3306,
    "dialect": "mysql"
  },
  "production": {
    "username": "usuario_producao",
    "password": "senha_producao",
    "database": "neuroflux_production",
    "host": "host_producao",
    "port": 3306,
    "dialect": "mysql"
  }
}
```

> Resumo: o projeto já vem com `.env.example` e `config/config.json.example`.  
> Para configurar, basta editar os valores desses arquivos de acordo com o ambiente de quem está usando o projeto.

---

## 4. Criar o banco de dados no MySQL

Acesse o MySQL e execute:

```sql
CREATE DATABASE neuroflux
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Confirme se o usuário informado nos arquivos de configuração possui permissão para acessar esse banco.

---

## 5. Rodar as migrations

Com o banco criado e os arquivos de configuração ajustados, execute:

```bash
npx sequelize-cli db:migrate
```

Esse comando cria as tabelas necessárias no banco.

---

## 6. Iniciar o servidor

```bash
npm start
```

Saída esperada:

```text
DB sincronizado e MySQL conectado!
Servidor Neuroflux rodando em http://localhost:3000
```

---

## 7. Testar a API

No navegador ou terminal, acesse:

```bash
curl http://localhost:3000
```

Resposta esperada:

```text
API Neuroflux funcionando
```

---

## Arquivos de configuração

O projeto já possui os dois arquivos de exemplo usados para configuração:

| Arquivo no repositório | Finalidade |
|------------------------|------------|
| `.env.example` | Configurar porta, banco de dados e chave JWT |
| `config/config.json.example` | Configurar o Sequelize e as migrations |

Esses arquivos servem para orientar quem for rodar o backend localmente.

Cada pessoa deve alterar os valores conforme o próprio ambiente, principalmente:

- usuário do MySQL;
- senha do MySQL;
- nome do banco;
- host;
- porta;
- chave JWT.

---

## Banco de dados

### Models principais

O backend possui três entidades principais:

```text
Usuario 1:N Tarefa
Tarefa 1:N Subtarefa
```

### Usuario

| Campo | Descrição |
|------|-----------|
| `id` | Identificador do usuário |
| `nome` | Nome do usuário |
| `email` | E-mail único |
| `senha` | Senha criptografada |
| `role` | Perfil do usuário: `user` ou `admin` |

### Tarefa

| Campo | Descrição |
|------|-----------|
| `id` | Identificador da tarefa |
| `titulo` | Título da tarefa |
| `descricao` | Descrição da tarefa |
| `concluida` | Status de conclusão |
| `usuarioId` | Usuário dono da tarefa |

### Subtarefa

| Campo | Descrição |
|------|-----------|
| `id` | Identificador da subtarefa |
| `titulo` | Título da subtarefa |
| `concluida` | Status de conclusão |
| `tarefaId` | Tarefa relacionada |

---

## Executando o servidor

Para rodar o backend:

```bash
npm start
```

Por padrão, a API sobe em:

```text
http://localhost:3000
```

---

## Endpoints da API

Base URL:

```text
http://localhost:3000
```

### Rotas públicas

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/` | Teste de funcionamento da API |
| `GET` | `/teste-user` | Rota simples de teste |
| `POST` | `/register` | Cadastro de usuário |
| `POST` | `/login` | Login e geração de token JWT |

---

### Rotas protegidas

As rotas protegidas precisam do header:

```http
Authorization: Bearer <token>
```

### Usuários

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/usuarios` | Lista usuários |
| `GET` | `/usuarios/:id` | Busca usuário por ID |
| `PUT` | `/usuarios/:id` | Atualiza usuário |
| `DELETE` | `/usuarios/:id` | Exclui usuário |

### Tarefas

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/tarefas` | Cria uma tarefa |
| `GET` | `/tarefas` | Lista tarefas |
| `GET` | `/tarefas/:id` | Busca tarefa por ID |
| `PUT` | `/tarefas/:id` | Atualiza tarefa |
| `DELETE` | `/tarefas/:id` | Remove tarefa |

### Subtarefas

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/subtarefas` | Cria uma subtarefa |
| `GET` | `/subtarefas` | Lista subtarefas |
| `GET` | `/subtarefas/:id` | Busca subtarefa por ID |
| `PUT` | `/subtarefas/:id` | Atualiza subtarefa |
| `DELETE` | `/subtarefas/:id` | Remove subtarefa |

---

## Autenticação e permissões

O backend utiliza autenticação via **JWT**.

Ao fazer login, a API retorna um token:

```json
{
  "message": "Login bem-sucedido!",
  "accessToken": "token_jwt",
  "expiresIn": "1h"
}
```

Esse token deve ser enviado nas rotas protegidas:

```http
Authorization: Bearer token_jwt
```

### Perfis

| Role | Descrição |
|------|-----------|
| `user` | Usuário comum |
| `admin` | Administrador |

---

## Exemplos de requisições

### Cadastro

```bash
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d "{
    \"nome\": \"Gabriel\",
    \"email\": \"gabriel@email.com\",
    \"senha\": \"123456\"
  }"
```

---

### Login

```bash
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"gabriel@email.com\",
    \"senha\": \"123456\"
  }"
```

---

### Criar tarefa

```bash
curl -X POST http://localhost:3000/tarefas \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d "{
    \"titulo\": \"Estudar API REST\",
    \"descricao\": \"Revisar rotas, controllers e autenticação JWT\"
  }"
```

---

### Listar tarefas

```bash
curl -X GET http://localhost:3000/tarefas \
  -H "Authorization: Bearer SEU_TOKEN"
```

---

### Criar subtarefa

```bash
curl -X POST http://localhost:3000/subtarefas \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d "{
    \"titulo\": \"Revisar controllers\",
    \"tarefaId\": 1
  }"
```

---

## Solução de problemas

| Problema | Possível causa | Solução |
|----------|----------------|---------|
| `Erro ao iniciar o servidor` | MySQL desligado | Inicie o MySQL |
| `Access denied for user` | Usuário ou senha incorretos | Revise os arquivos `.env.example` e `config/config.json.example` |
| `Unknown database` | Banco não criado | Execute o `CREATE DATABASE neuroflux` |
| `JWT_SECRET undefined` | Chave JWT não configurada | Verifique o valor de `JWT_SECRET` |
| `Não autorizado` | Token não enviado | Envie `Authorization: Bearer <token>` |
| `Token inválido ou expirado` | Token expirado | Faça login novamente |
| Tarefas não aparecem no app | API desligada ou URL errada | Confirme se o backend está rodando em `localhost:3000` |

---

## Contexto acadêmico

Este backend faz parte do projeto acadêmico **NeuroFlux**, uma solução full stack voltada à organização de tarefas para pessoas neurodivergentes, especialmente pessoas com TDAH.

O objetivo da API é demonstrar:

- Criação de servidor com Node.js e Express;
- Integração com banco relacional MySQL;
- Uso de ORM com Sequelize;
- Autenticação com JWT;
- Controle de permissões;
- Estruturação de rotas, controllers, models e middlewares;
- Comunicação com frontend Flutter por meio de API REST.

---

## Licença

Projeto acadêmico — consulte os autores da disciplina/instituição para termos de uso e distribuição.

## Integrantes

| Nome | Matrícula |
|------|-----------|
| Felipe Gabriel dos Santos Vasconcelos | 16036165 |
| José Guilherme da Silva Nascimento | 16034504 |
| Yuri Cruz Brandão | 16036094 |
| Jorge Felipe Trindade Mendonça | 16035609 |
| Gabriel David Vacirca | 16035571 |
| Brigitte Lara Rodrigues Pereira da Silva Dantas | 16035243 |
