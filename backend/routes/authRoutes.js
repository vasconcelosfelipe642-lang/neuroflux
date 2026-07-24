const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/AuthController');

router.post('/esqueci-senha', AuthController.esqueciSenha);

router.post('/resetar-senha', AuthController.resetarSenha);

module.exports = router;