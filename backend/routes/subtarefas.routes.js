const express = require('express');
console.log('Subtarefas routes carregadas');
const router = express.Router();
const subtarefaController = require('../controllers/subtarefaController');
const { verifyToken } = require('../middlewares/auth');

router.post('/subtarefas',verifyToken,subtarefaController.store);
router.get('/subtarefas',verifyToken,subtarefaController.index);
router.put('/subtarefas/:id',verifyToken,subtarefaController.update);
router.delete('/subtarefas/:id',verifyToken,subtarefaController.delete);

module.exports = router;