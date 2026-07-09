'use strict';

const bcrypt = require('bcryptjs');
const { Usuario } = require('../models');
const {
  USER_ROLES,
  normalizeRole,
  isValidRole,
  isPublicSignUpRole,
  isAdminRole,
} = require('../constants/userRoles');
const {
  issueTokenPair,
  verifyRefreshToken,
  hashRefreshToken,
} = require('../services/tokenService');

const SAFE_USER_ATTRIBUTES = ['id', 'nome', 'email', 'role'];

function toSafeUser(usuario) {
  const plain = usuario.get ? usuario.get({ plain: true }) : usuario;
  return {
    id: plain.id,
    nome: plain.nome,
    email: plain.email,
    role: plain.role,
  };
}

function buildUserUpdatePayload(body, canUpdateRole) {
  const payload = {};

  if (body.nome !== undefined) payload.nome = body.nome;
  if (body.email !== undefined) payload.email = body.email;
  if (body.senha !== undefined) payload.senha = body.senha;

  if (body.role !== undefined) {
    if (!canUpdateRole) {
      return {
        error: {
          status: 403,
          message: 'Apenas administradores podem alterar tipo de usuario',
        },
      };
    }

    const role = normalizeRole(body.role);
    if (!isValidRole(role)) {
      return {
        error: {
          status: 400,
          message: 'Tipo de usuario invalido',
        },
      };
    }

    payload.role = role;
  }

  return { payload };
}

module.exports = {
  async store(req, res) {
    try {
      const { nome, email, senha, role } = req.body;

      if (!nome || !email || !senha) {
        return res.status(400).json({ error: 'Campos obrigatorios ausentes' });
      }

      const normalizedRole = normalizeRole(role, USER_ROLES.COMMON);
      if (!isPublicSignUpRole(normalizedRole)) {
        return res.status(400).json({
          error: 'Tipo de usuario invalido para cadastro publico',
        });
      }

      const usuario = await Usuario.create({
        nome,
        email,
        senha,
        role: normalizedRole,
      });

      const tokens = await issueTokenPair(usuario);

      return res.status(201).json({
        message: 'Usuario criado com sucesso!',
        ...tokens,
      });
    } catch (error) {
      console.error('ERRO NO STORE:', error);

      if (error.name === 'SequelizeUniqueConstraintError') {
        return res.status(409).json({ error: 'Este e-mail ja esta em uso' });
      }

      return res.status(400).json({
        error: 'Erro ao criar usuario',
        details: error.message,
      });
    }
  },

  async show(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id, {
        attributes: SAFE_USER_ATTRIBUTES,
      });

      if (!usuario) {
        return res.status(404).json({ error: 'Usuario nao encontrado' });
      }

      if (Number(id) !== req.user.id && !isAdminRole(req.user.role)) {
        return res.status(403).json({
          error: 'Voce nao tem permissao para ver este usuario',
        });
      }

      return res.json(usuario);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar usuario' });
    }
  },

  async login(req, res) {
    try {
      const { email, senha } = req.body;

      if (!email || !senha) {
        return res.status(400).json({ error: 'E-mail e senha sao obrigatorios' });
      }

      const usuario = await Usuario.findOne({ where: { email } });

      if (!usuario || !(await bcrypt.compare(senha, usuario.senha))) {
        return res.status(401).json({ message: 'Credenciais invalidas.' });
      }

      const tokens = await issueTokenPair(usuario);

      return res.status(200).json({
        message: 'Login bem-sucedido!',
        ...tokens,
      });
    } catch (error) {
      return res.status(500).json({ error: 'Erro interno no servidor' });
    }
  },

  async refreshToken(req, res) {
    try {
      const { refreshToken } = req.body;
      if (!refreshToken) {
        return res.status(400).json({ error: 'Refresh token obrigatorio' });
      }

      const payload = verifyRefreshToken(refreshToken);
      if (payload.type !== 'refresh') {
        return res.status(401).json({ error: 'Refresh token invalido' });
      }

      const usuario = await Usuario.findByPk(payload.sub);
      const tokenHash = hashRefreshToken(refreshToken);
      const isStoredTokenValid = usuario
        && usuario.refreshTokenHash === tokenHash
        && usuario.refreshTokenExpiresAt
        && new Date(usuario.refreshTokenExpiresAt).getTime() > Date.now();

      if (!isStoredTokenValid) {
        return res.status(401).json({ error: 'Refresh token invalido ou expirado' });
      }

      const tokens = await issueTokenPair(usuario);
      return res.json(tokens);
    } catch (error) {
      return res.status(401).json({ error: 'Refresh token invalido ou expirado' });
    }
  },

  async logout(req, res) {
    try {
      const { refreshToken } = req.body;
      if (!refreshToken) {
        return res.status(204).send();
      }

      await Usuario.update(
        { refreshTokenHash: null, refreshTokenExpiresAt: null },
        { where: { refreshTokenHash: hashRefreshToken(refreshToken) } },
      );

      return res.status(204).send();
    } catch (error) {
      return res.status(204).send();
    }
  },

  async index(req, res) {
    try {
      const usuarios = await Usuario.findAll({
        attributes: SAFE_USER_ATTRIBUTES,
      });

      return res.json(usuarios);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao listar usuarios' });
    }
  },

  async update(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) {
        return res.status(404).json({ error: 'Usuario nao encontrado' });
      }

      const canUpdateRole = isAdminRole(req.user.role);
      const isUpdatingSelf = Number(id) === req.user.id;

      if (!canUpdateRole && !isUpdatingSelf) {
        return res.status(403).json({
          error: 'Voce nao tem permissao para atualizar este usuario',
        });
      }

      const { payload, error } = buildUserUpdatePayload(req.body, canUpdateRole);
      if (error) {
        return res.status(error.status).json({ error: error.message });
      }

      await usuario.update(payload);
      return res.json(toSafeUser(usuario));
    } catch (error) {
      if (error.name === 'SequelizeUniqueConstraintError') {
        return res.status(409).json({ error: 'Este e-mail ja esta em uso' });
      }

      return res.status(400).json({ error: 'Erro ao atualizar usuario' });
    }
  },

  async delete(req, res) {
    try {
      const { id } = req.params;
      const usuario = await Usuario.findByPk(id);

      if (!usuario) {
        return res.status(404).json({ error: 'Usuario nao encontrado' });
      }

      await usuario.destroy();
      return res.json({ message: 'Usuario movido para a lixeira' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar usuario' });
    }
  },
};
