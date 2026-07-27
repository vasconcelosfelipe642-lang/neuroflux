const express = require('express');
console.log('Tarefas routes carregadas');
const router = express.Router();
const TarefaController = require('../controllers/TarefaController');
const { verifyToken, isAdmin } = require('../middlewares/auth');
const authorize = require('../middlewares/authorize');

// Todas as rotas de tarefa requerem autenticação
router.post('/tarefas', verifyToken, TarefaController.store);
router.get('/tarefas', verifyToken, TarefaController.index);
router.get('/tarefas/:id', verifyToken, TarefaController.show);
router.patch('/tarefas/:id/concluir', verifyToken, TarefaController.updateCompletionStatus); 
router.put('/tarefas/:id', verifyToken, TarefaController.update);

// Apenas admin ou o criador da tarefa pode deletar
router.delete('/tarefas/:id', verifyToken, TarefaController.delete);

module.exports = router;