const { Tarefa, Subtarefa} = require('../models');

const isAppMetricsRequest = (req) => {
  const headerValue = req.headers['x-app-client'];
  return headerValue === 'true' || headerValue === '1';
};

module.exports = {
  // [POST] 
  async store(req, res) {
    try {
      if (req.user && req.user.role === 'admin') {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem criar subtarefas.' });
      }

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
      if (req.user && req.user.role === 'admin' && !isAppMetricsRequest(req)) {
        return res.json([]);
      }

      const tarefaUsuarioId = isAppMetricsRequest(req) && req.query && req.query.userId
        ? req.query.userId
        : (req.user.role !== 'admin' ? req.user.id : undefined);

      const subtarefas = await Subtarefa.findAll({
        attributes: ['id', 'titulo', 'concluida'], 
        include: [{
          model: Tarefa,
          as: 'tarefa',
          attributes: ['id', 'titulo', 'usuarioId', 'descricao', 'concluida'], 
          where: tarefaUsuarioId ? { usuarioId: tarefaUsuarioId } : {},
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
      if (req.user && req.user.role === 'admin' && !isAppMetricsRequest(req)) {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem visualizar subtarefas.' });
      }

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
      if (req.user && req.user.role === 'admin') {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem editar subtarefas.' });
      }

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
      if (req.user && req.user.role === 'admin') {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem deletar subtarefas.' });
      }

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