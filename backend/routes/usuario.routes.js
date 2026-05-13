const express = require('express');

console.log('Usuario routes carregadas');

const router = express.Router();

router.get('/teste-user', (req, res) => {
  return res.send('funcionou');
});

const usuarioController = require(
  '../controllers/UsuarioController'
);

router.post(
  '/usuarios',
  usuarioController.store
);


router.get(
  '/usuarios',
  usuarioController.index
);

router.put(
  '/usuarios/:id',
  usuarioController.update
);

router.delete(
  '/usuarios/:id',
  usuarioController.delete
);

module.exports = router;