'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Tarefas', 'concluida_em', {
      type: Sequelize.DATE,
      allowNull: true
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Tarefas', 'concluida_em');
  }
};
