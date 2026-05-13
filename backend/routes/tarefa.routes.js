const express = require('express');

console.log('Tarefas routes carregadas');

const router = express.Router();

const tarefaController = require(
  '../controllers/tarefaController'
);

router.post(
  '/tarefas',
  tarefaController.store
);

router.get(
  '/tarefas',
  tarefaController.index
);

router.put(
  '/tarefas/:id',
  tarefaController.update
);

router.delete(
  '/tarefas/:id',
  tarefaController.delete
);

module.exports = router;