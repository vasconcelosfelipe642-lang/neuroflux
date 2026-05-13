require('dotenv').config();

const express = require('express');
const cors = require('cors');

const usuarioRoutes =require(
  './routes/usuario.routes'
);

const tarefaRoutes = require(
  './routes/tarefa.routes'
);

const subtarefaRoutes = require(
  './routes/subtarefas.routes'
);

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('API funcionando');
});

app.use(usuarioRoutes);
app.use(tarefaRoutes);
app.use(subtarefaRoutes);

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});