const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middlewares/auth');
const usuarioRoutes = require('./usuario.routes');
const tarefaRoutes = require('./tarefa.routes');
const subtarefasRoutes = require('./subtarefas.routes');
// Rotas públicas
router.use(usuarioRoutes); 
// As rotas de usuário não exigem uma autenticação, pois são usadas para registro e login
router.use(verifyToken); 
// Rotas protegidas por autenticação
router.use(tarefaRoutes);
router.use(subtarefasRoutes);

module.exports = router;