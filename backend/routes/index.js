const express = require('express');
const router = express.Router();

// Importar rotas
const tarefaRoutes = require('./tarefa.routes');
const subtarefaRoutes = require('./subtarefas.routes');

// Usar rotas
router.use('/', tarefaRoutes);
router.use('/', subtarefaRoutes);

module.exports = router;