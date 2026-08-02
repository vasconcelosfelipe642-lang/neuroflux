const express = require('express');
console.log('Usuario routes carregadas');
const router = express.Router();
const usuarioController = require('../controllers/UsuarioController');
const { verifyToken, isAdmin } = require('../middlewares/auth');

// Rotas públicas
router.get('/teste-user', (req, res) => {
  return res.send('funcionou');
});

router.post('/register', usuarioController.store); 
router.post('/login', usuarioController.login);    
router.post('/refresh-token', usuarioController.refreshToken);
router.post('/logout', usuarioController.logout);

// Rotas protegidas - apenas admin pode listar e deletar
router.get('/usuarios', verifyToken, isAdmin, usuarioController.index);
router.get('/usuarios/:id', verifyToken, usuarioController.show);
router.put('/usuarios/:id', verifyToken, usuarioController.update);
router.delete('/usuarios/:id', verifyToken,isAdmin, usuarioController.delete);
router.post('/usuarios/forgot-password', usuarioController.forgotPassword);
router.post('/usuarios/reset-password', usuarioController.resetPassword);

module.exports = router;
