const { Router } = require('express');
const tarefaController = require('../controllers/tarefaController');

const router = Router();

router.post('/tarefas', tarefaController.store);
router.get('/tarefas', tarefaController.index);
router.put('/tarefas/:id', tarefaController.update);
router.delete('/tarefas/:id', tarefaController.delete);

module.exports = router;