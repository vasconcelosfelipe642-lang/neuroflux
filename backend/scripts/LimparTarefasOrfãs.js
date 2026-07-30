const db = require('../models');

async function LimparTarefasOrfãs() {
  try {
    const { Tarefa, Subtarefa } = db;

    const tarefasOrfãs = await Tarefa.findAll({
      where: { usuarioId: null },
      include: [{ model: Subtarefa, as: 'subtarefas' }],
    });

    for (const tarefa of tarefasOrfãs) {
      await tarefa.destroy();
    }

    console.log(`Tarefas órfãs removidas: ${tarefasOrfãs.length}`);
  } catch (error) {
    console.error('Erro ao limpar tarefas órfãs:', error);
  } finally {
    await db.sequelize.close();
  }
}

LimparTarefasOrfãs();
