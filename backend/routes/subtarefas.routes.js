const { Router } = require('express');
const subtarefaController = require('../controllers/subtarefaController');

const router = Router();

router.post('/subtarefas', subtarefaController.store);
router.get('/subtarefas', subtarefaController.index);
router.put('/subtarefas/:id', subtarefaController.update);
router.delete('/subtarefas/:id', subtarefaController.delete);

module.exports = router;