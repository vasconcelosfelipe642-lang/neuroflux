const { Usuario } = require('../models');
const bcrypt = require('bcrypt'); 
const jwt = require('jsonwebtoken'); 
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
  async store(req, res) {
    try {
      const { nome, email, senha } = req.body;

      if (!nome || !email || !senha) {
        return res.status(400).json({ error: 'Campos obrigatórios ausentes' });
      }
      const usuario = await Usuario.create({ nome, email, senha });

      const token = generateAccessToken(usuario);

      return res.status(201).json({
        message: 'Usuário criado com sucesso!',
        token
      });
    } catch (error) {
      if (error.name === 'SequelizeUniqueConstraintError') {
        return res.status(409).json({ error: 'Este e-mail já está em uso' }); 
      }
      return res.status(400).json({ error: 'Erro ao criar usuário' });
    }
  },

  async login(req, res) {
    try {
      const { email, senha } = req.body;

      const usuario = await Usuario.findOne({ where: { email } });
      if (!usuario || !(await bcrypt.compare(senha, usuario.senha))) {
        return res.status(401).json({ message: 'Credenciais inválidas.' }); // 
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
  // GET
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

  // PUT
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

  // DELETE
  async delete(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) return res.status(404).json({ error: 'Usuário não encontrado' });

      await usuario.destroy(); // Apenas preenche deletedAt
      return res.json({ message: 'Usuário movido para a lixeira' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar usuário' });
    }
  }
};