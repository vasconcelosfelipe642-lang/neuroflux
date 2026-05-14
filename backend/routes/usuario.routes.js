const express = require('express');
console.log('Usuario routes carregadas');
const router = express.Router();
const usuarioController = require('../controllers/UsuarioController');
const { verifyToken, isAdmin } = require('../middlewares/auth');
const authorize = require('../middlewares/authorize');

// Rotas públicas
router.get('/teste-user', (req, res) => {
  return res.send('funcionou');
});

router.post('/register', usuarioController.store); 
router.post('/login', usuarioController.login);    

// Rotas protegidas - apenas admin pode listar e deletar
router.get('/usuarios', verifyToken, usuarioController.index);
router.put('/usuarios/:id', verifyToken, usuarioController.update);
router.delete('/usuarios/:id', verifyToken,isAdmin, usuarioController.delete);

module.exports = router;