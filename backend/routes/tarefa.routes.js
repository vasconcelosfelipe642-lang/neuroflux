const express = require('express');
console.log('Tarefas routes carregadas');
const router = express.Router();
const tarefaController = require('../controllers/tarefaController');
const { verifyToken, isAdmin } = require('../middlewares/auth');
const authorize = require('../middlewares/authorize');

router.post('/tarefas', verifyToken, tarefaController.store);
router.get('/tarefas', verifyToken, tarefaController.index);
router.get('/tarefas/:id', verifyToken, tarefaController.show);
router.put('/tarefas/:id', verifyToken, tarefaController.update);

router.delete('/tarefas/:id', verifyToken, tarefaController.delete);

module.exports = router;