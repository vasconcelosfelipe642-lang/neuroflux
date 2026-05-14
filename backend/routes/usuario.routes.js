const express = require('express');
console.log('Usuario routes carregadas');
const router = express.Router();
const usuarioController = require('../controllers/UsuarioController');
const { verifyToken, isAdmin } = require('../middlewares/auth');
router.get('/teste-user', (req, res) => {
  return res.send('funcionou');
});

router.post('/register', usuarioController.store); 
router.post('/login', usuarioController.login);    
router.get('/usuarios', verifyToken, isAdmin, usuarioController.index);
router.put('/usuarios/:id', verifyToken, usuarioController.update);
router.delete('/usuarios/:id', verifyToken, usuarioController.delete);

module.exports = router;