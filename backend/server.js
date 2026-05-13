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

// Sincroniza o banco e inicia o servidor
db.sequelize.authenticate()
  .then(() => {
    console.log(' Conectado ao MySQL com sucesso!');
    app.listen(PORT, () => console.log(`Servidor Neuroflux em http://localhost:${PORT}`));
  })
  .catch(err => console.error(' Erro de conexão:', err));