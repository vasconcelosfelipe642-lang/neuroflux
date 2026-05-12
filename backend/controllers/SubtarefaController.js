const { Subtarefa } = require('../models');

module.exports = {
  async store(req, res) {
    try {
      const { titulo, tarefa_id } = req.body;

      const subtarefa = await Subtarefa.create({
        titulo,
        tarefa_id
      });

      return res.status(201).json(subtarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao criar subtarefa.' });
    }
  },

  async update(req, res) {
    try {
      const { id } = req.params;
      const { concluida } = req.body;

      const subtarefa = await Subtarefa.findByPk(id);

      if (!subtarefa) {
        return res.status(404).json({ error: 'Subtarefa não encontrada.' });
      }

      await subtarefa.update({ concluida });

      return res.json(subtarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao atualizar subtarefa.' });
    }
  }
};