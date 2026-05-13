const { Subtarefa } = require('../models');

module.exports = {
  // [POST] 
  async store(req, res) {
    try {
      const { titulo, tarefaId } = req.body;
      const subtarefa = await Subtarefa.create({ titulo, tarefaId });
      return res.status(201).json(subtarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao criar subtarefa.' });
    }
  },

  // [GET] 
  async index(req, res) {
    try {
      const { tarefaId } = req.query; 
      const subtarefas = await Subtarefa.findAll({ where: { tarefaId } });
      return res.json(subtarefas);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar subtarefas.' });
    }
  },

  // [PUT]
  async update(req, res) {
    try {
      const { id } = req.params;
      const { titulo, concluida } = req.body;
      const subtarefa = await Subtarefa.findByPk(id);

      if (!subtarefa) return res.status(404).json({ error: 'Subtarefa não encontrada.' });

      await subtarefa.update({ titulo, concluida });
      return res.json(subtarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao atualizar subtarefa.' });
    }
  },

  // [DELETE]
  async delete(req, res) {
    try {
      const { id } = req.params;
      const subtarefa = await Subtarefa.findByPk(id);

      if (!subtarefa) return res.status(404).json({ error: 'Subtarefa não encontrada.' });

      await subtarefa.destroy();
      return res.json({ message: 'Subtarefa removida.' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar subtarefa.' });
    }
  }
};