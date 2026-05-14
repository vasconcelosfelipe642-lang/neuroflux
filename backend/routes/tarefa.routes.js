const express = require('express');
console.log('Tarefas routes carregadas');
const router = express.Router();
const tarefaController = require('../controllers/tarefaController');
const { verifyToken, isAdmin } = require('../middlewares/auth');
const authorize = require('../middlewares/authorize');

// Todas as rotas de tarefa requerem autenticação
router.post('/tarefas', verifyToken, tarefaController.store);
router.get('/tarefas', verifyToken, tarefaController.index);
router.put('/tarefas/:id', verifyToken, tarefaController.update);

// Apenas admin ou o criador da tarefa pode deletar
router.delete('/tarefas/:id', verifyToken, tarefaController.delete);

module.exports = router;