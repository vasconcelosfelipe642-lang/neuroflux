require('dotenv').config(); 
const express = require('express');
const cors = require('cors');
const db = require('./models'); 
const routes = require('./routes'); 

const app = express();

app.use(cors());
app.use(express.json()); 

app.get('/', (req, res) => {
  res.send('API Neuroflux funcionando');
});

app.use(routes);

const PORT = process.env.PORT || 3000;

async function startServer() {
  try {
    await db.sequelize.sync(); 
    console.log('DB sincronizado e MySQL conectado!'); 

    app.listen(PORT, () => {
      console.log(`Servidor Neuroflux rodando em http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('Erro ao iniciar o servidor:', err); 
  }
}

startServer(); 