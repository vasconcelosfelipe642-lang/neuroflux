const { Usuario } = require('../models');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { sendPasswordResetEmail } = require('../services/emailService');
require('dotenv').config();

function generateAccessToken(usuario) {
  return jwt.sign(
    {
      id: usuario.id,
      nome: usuario.nome,
      role: usuario.role
    },
    process.env.JWT_SECRET,
    { expiresIn: '1h' }
  );
}

module.exports = {
  // [POST]
  // [POST] Solicitar recuperação de senha
  async forgotPassword(req, res) {
    try {
      const { email } = req.body;
      const usuario = await Usuario.findOne({ where: { email } });

      // Por segurança, sempre retornamos sucesso, mesmo se o e-mail
      // não existir — assim não revelamos quais e-mails estão cadastrados.
      if (!usuario) {
        return res.status(200).json({
          message: 'Se este e-mail estiver cadastrado, enviaremos instruções para recuperação.'
        });
      }

      // Gera um código de 6 dígitos
      const resetToken = crypto.randomInt(100000, 999999).toString();
      const resetExpires = new Date(Date.now() + 30 * 60 * 1000); // 30 minutos

      await usuario.update({
        resetPasswordToken: resetToken,
        resetPasswordExpires: resetExpires,
      });

      await sendPasswordResetEmail(usuario.email, usuario.nome, resetToken);

      return res.status(200).json({
        message: 'Se este e-mail estiver cadastrado, enviaremos instruções para recuperação.'
      });
    } catch (error) {
      console.error('ERRO NO FORGOT PASSWORD:', error);
      return res.status(500).json({ error: 'Erro ao processar solicitação.' });
    }
  },

  // [POST] Confirmar redefinição de senha com o código recebido por e-mail
  async resetPassword(req, res) {
    try {
      const { email, token, novaSenha } = req.body;

      if (!email || !token || !novaSenha) {
        return res.status(400).json({ error: 'Dados incompletos.' });
      }

      const usuario = await Usuario.findOne({ where: { email } });

      if (
        !usuario ||
        usuario.resetPasswordToken !== token ||
        !usuario.resetPasswordExpires ||
        new Date() > usuario.resetPasswordExpires
      ) {
        return res.status(400).json({ error: 'Código inválido ou expirado.' });
      }

      await usuario.update({
        senha: novaSenha, // o hook beforeUpdate do model já criptografa
        resetPasswordToken: null,
        resetPasswordExpires: null,
      });

      return res.status(200).json({ message: 'Senha redefinida com sucesso!' });
    } catch (error) {
      console.error('ERRO NO RESET PASSWORD:', error);
      return res.status(500).json({ error: 'Erro ao redefinir senha.' });
    }
  },
  async store(req, res) {
    try {
      const { nome, email, senha, role } = req.body;

      if (!nome || !email || !senha) {
        return res.status(400).json({ error: 'Campos obrigatórios ausentes' });
      }

      const usuario = await Usuario.create({
        nome,
        email,
        senha,
        role: role || 'user'
      });

      const usuarioDados = usuario.get({ plain: true });
      const token = generateAccessToken(usuarioDados);

      return res.status(201).json({
        message: 'Usuário criado com sucesso!',
        token
      });

    } catch (error) {
      console.error("ERRO NO STORE:", error);

      if (error.name === 'SequelizeUniqueConstraintError') {
        return res.status(409).json({ error: 'Este e-mail já está em uso' });
      }
      return res.status(400).json({
        error: 'Erro ao criar usuário',
        details: error.message
      });
    }
  },
  // [GET - ID]
  async show(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id, {
        attributes: ['id', 'nome', 'email', 'role']
      });

      if (!usuario) {
        return res.status(404).json({ error: 'Usuário não encontrado' });
      }

      return res.json(usuario);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar usuário' });
    }
  },
  // [POST]
  async login(req, res) {
    try {
      const { email, senha } = req.body;

      const usuario = await Usuario.findOne({ where: { email } });

      if (!usuario || !(await bcrypt.compare(senha, usuario.senha))) {
        return res.status(401).json({ message: 'Credenciais inválidas.' });
      }

      const token = generateAccessToken(usuario);

      return res.status(200).json({
        message: 'Login bem-sucedido!',
        accessToken: token,
        expiresIn: '1h'
      });
    } catch (error) {
      return res.status(500).json({ error: 'Erro interno no servidor' });
    }
  },
  // [GET]
  async index(req, res) {
    try {
      const usuarios = await Usuario.findAll({
        attributes: ['id', 'nome', 'email', 'role']
      });
      return res.json(usuarios);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao listar usuários' });
    }
  },
  // [PUT]
  async update(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) return res.status(404).json({ error: 'Usuário não encontrado' });

      await usuario.update(req.body);
      return res.json({ message: 'Dados atualizados com sucesso' });
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao atualizar usuário' });
    }
  },
  // [DELETE]
  async delete(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) return res.status(404).json({ error: 'Usuário não encontrado' });

      await usuario.destroy();
      return res.json({ message: 'Usuário movido para a lixeira' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar usuário' });
    }
  }
};