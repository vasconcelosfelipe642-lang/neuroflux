const express = require('express');

console.log('Subtarefas routes carregadas');

const router = express.Router();

const subtarefaController = require(
  '../controllers/subtarefaController'
);

router.post(
  '/subtarefas',
  subtarefaController.store
);

router.get(
  '/subtarefas',
  subtarefaController.index
);

router.put(
  '/subtarefas/:id',
  subtarefaController.update
);

router.delete(
  '/subtarefas/:id',
  subtarefaController.delete
);

module.exports = router;