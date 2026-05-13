import { Router} from "express";
import tarefaController from "../controllers/tarefaController.js";

const router = Router();

router.post('/tarefas', tarefaController.store);
router.get('/tarefas', tarefaController.index);
router.put('/tarefas/:id', tarefaController.update);
router.delete('/tarefas/:id', tarefaController.delete);