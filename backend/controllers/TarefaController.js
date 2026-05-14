const { Tarefa } = require('../models');

module.exports = {
  
  async store(req, res) {
    try {
      console.log(req.body);
      const { titulo, descricao } = req.body;
      
      // Usa o ID do usuário autenticado, não do req.body
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

  
  async index(req, res) {
    try {
      let where = {};
      
      // Se não for admin, mostra apenas suas tarefas
      if (req.user.role !== 'admin') {
        where.usuarioId = req.user.id;
      }
      
      const tarefas = await Tarefa.findAll({ where });
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
      
      // Verifica se o usuário tem permissão para ver (é o criador ou é admin)
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

      // Verifica permissão - apenas o criador ou admin pode editar
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

      // Verifica permissão - apenas o criador ou admin pode deletar
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