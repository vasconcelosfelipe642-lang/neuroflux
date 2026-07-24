const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middlewares/auth');

const usuarioRoutes = require('./usuario.routes');
const tarefaRoutes = require('./tarefa.routes');
const subtarefasRoutes = require('./subtarefas.routes');
// Importe o novo arquivo de rotas (ajuste o nome se você tiver salvo diferente, ex: auth.routes.js)
const authRoutes = require('./authRoutes'); 

router.use(usuarioRoutes); 
router.use(authRoutes); 
router.use(verifyToken); 
router.use(tarefaRoutes);
router.use(subtarefasRoutes);

module.exports = router;