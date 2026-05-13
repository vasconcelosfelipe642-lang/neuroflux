const express = require('express');
const cors = require('cors');
const routes = require('./routes');
const db = require('./models');

const app = express();

app.use(cors());
app.use(express.json());
app.use(routes);

const PORT = 3000;

// Sincroniza o banco e inicia o servidor
db.sequelize.authenticate()
  .then(() => {
    console.log(' Conectado ao MySQL com sucesso!');
    app.listen(PORT, () => console.log(`Servidor Neuroflux em http://localhost:${PORT}`));
  })
  .catch(err => console.error(' Erro de conexão:', err));