const { Tarefa, Subtarefa } = require('../models');

module.exports = {
  
  // [POST]
  async store(req, res) {
    try {
      console.log(req.body);
      const { titulo, descricao } = req.body;

      const usuarioId = req.user.id;
      
      const tarefa = await Tarefa.create({ titulo, descricao, usuarioId });
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

  
  // [GET] Listar todas as tarefas com suas subtarefas
  async index(req, res) {
    try {
      let where = {};

      if (req.user.role !== 'admin') {
        where.usuarioId = req.user.id;
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

  // [GET - ID] Buscar uma tarefa específica com suas subtarefas
  async show(req, res) {
    try {
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

  // [PUT]
  async update(req, res) {
    try {
      const { id } = req.params;
      const { titulo, descricao, concluida } = req.body;
      const tarefa = await Tarefa.findByPk(id);

      if (!tarefa) return res.status(404).json({ error: 'Tarefa não encontrada.' });

      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para editar esta tarefa.' });
      }

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

      if (tarefa.usuarioId !== req.user.id && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Você não tem permissão para deletar esta tarefa.' });
      }

      await tarefa.destroy(); 
      return res.json({ message: 'Tarefa deletada com sucesso.' });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao deletar tarefa.' });
    }
  }
};