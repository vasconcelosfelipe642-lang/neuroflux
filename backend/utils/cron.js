const cron = require('node-cron');
const { Tarefa } = require('../models');

cron.schedule('0 0 * * *', async () => {
  try {
    await Tarefa.update(
      { concluida: false },
      { where: { is_diaria: true } }
    );
  } catch (error) {
    console.error(error);
  }
});