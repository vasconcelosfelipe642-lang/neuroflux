const { Tarefa, Subtarefa} = require('../models');

module.exports = {
  // [POST] 
  async store(req, res) {
    try {
      const { titulo, tarefaId } = req.body;

      const tarefa = await Tarefa.findByPk(tarefaId);
      if (!tarefa) {
        return res.status(404).json({ error: 'Tarefa não encontrada.' });
      }

      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para adicionar subtarefas a esta tarefa.' });
      }
      
      const subtarefa = await Subtarefa.create({ titulo, tarefaId });
      return res.status(201).json(subtarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao criar subtarefa.' });
    }
  },

// [GET] Listar todas as subtarefas
  async index(req, res) {
    try {
      const subtarefas = await Subtarefa.findAll({
        attributes: ['id', 'titulo', 'concluida'], 
        include: [{
          model: Tarefa,
          as: 'tarefa',
          attributes: ['id', 'titulo', 'usuarioId', 'descricao', 'concluida'], 
          where: req.user.role !== 'admin' ? { usuarioId: req.user.id } : {},
          required: true
        }]
      });

      return res.json(subtarefas);
    } catch (error) {
      console.error("ERRO NO INDEX:", error);
      return res.status(500).json({ error: 'Erro ao buscar subtarefas.' });
    }
  },

  // [GET - ID] Buscar uma específica
  async show(req, res) {
    try {
      const { id } = req.params;
      const subtarefa = await Subtarefa.findByPk(id, {
        attributes: ['id', 'titulo', 'concluida'],
        include: [{
          model: Tarefa,
          as: 'tarefa',
          attributes: ['id', 'titulo', 'usuarioId', 'descricao', 'concluida'] 
        }]
      });

      if (!subtarefa) {
        return res.status(404).json({ error: 'Subtarefa não encontrada.' });
      }

      if (subtarefa.tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Sem permissão.' });
      }

      return res.json(subtarefa);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar a subtarefa.' });
    }
  },

  // [PUT]
  async update(req, res) {
    try {
      const { id } = req.params;
      const { titulo, concluida } = req.body;
      const subtarefa = await Subtarefa.findByPk(id);

      if (!subtarefa) return res.status(404).json({ error: 'Subtarefa não encontrada.' });

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