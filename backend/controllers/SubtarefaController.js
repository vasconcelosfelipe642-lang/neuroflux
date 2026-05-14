const { Subtarefa, Tarefa } = require('../models');

module.exports = {
  // [POST] 
  async store(req, res) {
    try {
      const { titulo, tarefaId } = req.body;
      
      // Verifica se a tarefa existe e se o usuário tem permissão
      const tarefa = await Tarefa.findByPk(tarefaId);
      if (!tarefa) {
        return res.status(404).json({ error: 'Tarefa não encontrada.' });
      }
      
      // Apenas o criador da tarefa ou admin pode adicionar subtarefas
      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para adicionar subtarefas a esta tarefa.' });
      }
      
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
      
      // Verifica se a tarefa existe e se o usuário tem permissão para vê-la
      if (tarefaId) {
        const tarefa = await Tarefa.findByPk(tarefaId);
        if (!tarefa) {
          return res.status(404).json({ error: 'Tarefa não encontrada.' });
        }
        
        if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
          return res.status(403).json({ error: 'Você não tem permissão para ver as subtarefas desta tarefa.' });
        }
      }
      
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

      // Verifica permissão através da tarefa pai
      const tarefa = await Tarefa.findByPk(subtarefa.tarefaId);
      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para editar esta subtarefa.' });
      }

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

      // Verifica permissão através da tarefa pai
      const tarefa = await Tarefa.findByPk(subtarefa.tarefaId);
      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para deletar esta subtarefa.' });
      }

      await subtarefa.destroy();
      return res.json({ message: 'Subtarefa removida.' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar subtarefa.' });
    }
  }
};