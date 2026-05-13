const express = require('express');

const router = express.Router();

console.log('Rotas carregadas');

const usuarioRoutes =require(
  './usuario.routes'
);

const tarefaRoutes = require(
  './tarefa.routes'
);

const subtarefasRoutes = require(
  './subtarefas.routes'
);

router.use(usuarioRoutes);
router.use(tarefaRoutes);
router.use(subtarefasRoutes);

module.exports = router;