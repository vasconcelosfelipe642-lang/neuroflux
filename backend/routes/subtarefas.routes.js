import {router} from 'express';
import subtarefasController from '../controllers/subtarefasController.js';

const router = Router();

router.post('/subtarefas', subtarefasController.store);
router.get('/subtarefas', subtarefasController.index);
router.put('/subtarefas/:id', subtarefasController.update);
router.delete('/subtarefas/:id', subtarefasController.delete);