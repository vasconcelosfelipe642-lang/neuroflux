const express = require('express');
console.log('Tarefas routes carregadas');
const router = express.Router();
const tarefaController = require('../controllers/tarefaController');
const { verifyToken } = require('../middlewares/auth');

router.post('/tarefas',verifyToken,tarefaController.store);
router.get('/tarefas',verifyToken,tarefaController.index);
router.put('/tarefas/:id',verifyToken,tarefaController.update);
router.delete('/tarefas/:id',verifyToken,tarefaController.delete);

module.exports = router;