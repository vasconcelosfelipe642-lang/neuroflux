const express = require('express');
const router = express.Router();

// Importação desestruturada (pegando apenas o verifyToken do objeto)
const { verifyToken } = require('../middlewares/auth');

const usuarioRoutes = require('./usuario.routes');
const tarefaRoutes = require('./tarefa.routes');
const subtarefasRoutes = require('./subtarefas.routes');

// 1. Rotas de Usuário (Login/Register) ficam ANTES do middleware para serem públicas
router.use(usuarioRoutes); 

// 2. A partir daqui, tudo exige Token
router.use(verifyToken); 

// 3. Rotas protegidas
router.use(tarefaRoutes);
router.use(subtarefasRoutes);

module.exports = router;