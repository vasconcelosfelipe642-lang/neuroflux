const { Usuario } = require('../models');

module.exports = {
  // POST
  async store(req, res) {
    try {
      const {
        nome,
        email,
        senha
      } = req.body;

      const usuario =
      await Usuario.create({
        nome,
        email,
        senha
      });

      return res
      .status(201)
      .json(usuario);

    } catch (error) {
      console.error(error);

      return res.status(400).json({
        error:
        'Erro ao criar usuário'
      });
    }
  },

  // GET
  async index(req, res) {
    try {
      const usuarios =
      await Usuario.findAll();

      return res.json(
        usuarios
      );

    } catch (error) {
      return res.status(500).json({
        error:
        'Erro ao listar usuários'
      });
    }
  },

  // PUT
  async update(req, res) {
    try {
      const { id } =
      req.params;

      const usuario =
      await Usuario.findByPk(id);

      if (!usuario) {
        return res
        .status(404)
        .json({
          error:
          'Usuário não encontrado'
        });
      }

      await usuario.update(
        req.body
      );

      return res.json(
        usuario
      );

    } catch (error) {
      return res.status(400).json({
        error:
        'Erro ao atualizar usuário'
      });
    }
  },

  // DELETE
  async delete(req, res) {
    try {
      const { id } =
      req.params;

      const usuario =
      await Usuario.findByPk(id);

      if (!usuario) {
        return res
        .status(404)
        .json({
          error:
          'Usuário não encontrado'
        });
      }

      await usuario.destroy();

      return res.json({
        message:
        'Usuário removido'
      });

    } catch (error) {
      return res.status(500).json({
        error:
        'Erro ao deletar usuário'
      });
    }
  }
};