const express = require('express');
const router = express.Router();

const { verifyToken } = require('../middlewares/auth');

const usuarioRoutes = require('./usuario.routes');
const tarefaRoutes = require('./tarefa.routes');
const subtarefasRoutes = require('./subtarefas.routes');

router.use(usuarioRoutes); 

router.use(verifyToken); 

// 3. Rotas protegidas
router.use(tarefaRoutes);
router.use(subtarefasRoutes);

module.exports = router;