const { Tarefa, Subtarefa } = require('../models');

const isAppMetricsRequest = (req) => {
  const headerValue = req.headers['x-app-client'];
  return headerValue === 'true' || headerValue === '1';
};

module.exports = {
  
  async store(req, res) {
    try {
      if (req.user && req.user.role === 'admin') {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem criar tarefas.' });
      }

      console.log(req.body);
      const { titulo, descricao } = req.body;

      const { titulo, descricao, is_diaria } = req.body;
      const usuarioId = req.user.id;
      
      const tarefa = await Tarefa.create({ titulo, descricao, is_diaria, usuarioId });
      return res.status(201).json(tarefa);
    } catch (error) {
        console.error(error);
        return res.status(400).json({
          message: 'Erro ao criar tarefa',
          details: error.errors?.map(
            err => err.message
          ) || error.message
        });
    }
  },

  async index(req, res) {
    try {
      if (req.user && req.user.role === 'admin' && !isAppMetricsRequest(req)) {
        return res.json([]);
      }

      let where = {};
      if (req.user.role !== 'admin') {
        where.usuarioId = req.user.id;
      } else if (isAppMetricsRequest(req)) {
        const requestedUserId = req.query?.userId || req.query?.user_id;
        if (requestedUserId) {
          where.usuarioId = requestedUserId;
        }
      }
      
      const tarefas = await Tarefa.findAll({ 
        where,
        include: [{
          model: Subtarefa,
          as: 'subtarefas', 
          attributes: ['id', 'titulo', 'concluida'] 
        }]
      });
      
      return res.json(tarefas);
    } catch (error) {
      console.error("ERRO NO INDEX TAREFAS:", error);
      return res.status(500).json({ error: 'Erro ao buscar tarefas.' });
    }
  },

  async show(req, res) {
    try {
      if (req.user && req.user.role === 'admin' && !isAppMetricsRequest(req)) {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem visualizar tarefas.' });
      }

      const { id } = req.params;
      const tarefa = await Tarefa.findByPk(id, {
        include: [{
          model: Subtarefa,
          as: 'subtarefas',
          attributes: ['id', 'titulo', 'concluida']
        }]
      });
      
      if (!tarefa) {
        return res.status(404).json({ error: 'Tarefa não encontrada.' });
      }
      
      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para ver esta tarefa.' });
      }
      
      return res.json(tarefa);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao buscar a tarefa.' });
    }
  },

  async update(req, res) {
    try {
      if (req.user && req.user.role === 'admin') {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem editar tarefas.' });
      }

      const { id } = req.params;
      const { titulo, descricao, concluida, is_diaria } = req.body;
      const tarefa = await Tarefa.findByPk(id);

      if (!tarefa) return res.status(404).json({ error: 'Tarefa não encontrada.' });

      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para editar esta tarefa.' });
      }

      await tarefa.update({ titulo, descricao, concluida, is_diaria });
      return res.json(tarefa);
    } catch (error) {
      return res.status(400).json({ error: 'Erro ao atualizar.' });
    }
  },

  async delete(req, res) {
    try {
      if (req.user && req.user.role === 'admin') {
        return res.status(403).json({ error: 'Usuários com perfil admin não podem deletar tarefas.' });
      }

      const { id } = req.params;
      const tarefa = await Tarefa.findByPk(id, {
        include: [{
          model: Subtarefa,
          as: 'subtarefas'
        }]
      });

      if (!tarefa) return res.status(404).json({ error: 'Tarefa não encontrada.' });

      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para deletar esta tarefa.' });
      }
      await tarefa.destroy(); 
      
      return res.json({ message: 'Tarefa deletada com sucesso.' });
    } catch (error) {
      console.error("ERRO AO DELETAR TAREFA:", error);
      return res.status(500).json({ error: 'Erro ao deletar tarefa.', details: error.message });
    }
  }
};