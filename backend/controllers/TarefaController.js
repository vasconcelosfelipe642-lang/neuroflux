const { Tarefa } = require('../models');

module.exports = {
  // [POST]
  async store(req, res) {
    try {
      const { titulo, descricao, usuario_id } = req.body;
      const tarefa = await Tarefa.create({ titulo, descricao, usuario_id });
      return res.status(201).json(tarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao criar tarefa.' });
    }
  },

  // [GET]
  async index(req, res) {
    try {
      const tarefas = await Tarefa.findAll();
      return res.json(tarefas);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar tarefas.' });
    }
  },

  // [GET - ID]
  async show(req, res) {
    try {
      const { id } = req.params;
      const tarefa = await Tarefa.findByPk(id);
      
      if (!tarefa) return res.status(404).json({ error: 'Tarefa não encontrada.' });
      
      return res.json(tarefa);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar a tarefa.' });
    }
  },

  // [PUT]
  async update(req, res) {
    try {
      const { id } = req.params;
      const { titulo, descricao, concluida } = req.body;
      const tarefa = await Tarefa.findByPk(id);

      if (!tarefa) return res.status(404).json({ error: 'Tarefa não encontrada.' });

      await tarefa.update({ titulo, descricao, concluida });
      return res.json(tarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao atualizar.' });
    }
  },

  // [DELETE]
  async delete(req, res) {
    try {
      const { id } = req.params;
      const tarefa = await Tarefa.findByPk(id);

      if (!tarefa) return res.status(404).json({ error: 'Tarefa não encontrada.' });

      await tarefa.destroy(); 
      return res.json({ message: 'Tarefa deletada com sucesso.' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar tarefa.' });
    }
  }
};