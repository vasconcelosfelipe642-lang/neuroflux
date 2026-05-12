module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Subtarefas', {
      id: { allowNull: false, autoIncrement: true, primaryKey: true, type: Sequelize.INTEGER },
      titulo: { type: Sequelize.STRING, allowNull: false },
      concluida: { type: Sequelize.BOOLEAN, defaultValue: false },
      tarefa_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'Tarefas', key: 'id' }, // Chave estrangeira
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      createdAt: { allowNull: false, type: Sequelize.DATE },
      updatedAt: { allowNull: false, type: Sequelize.DATE }
    });
  },
  async down(queryInterface, Sequelize) { await queryInterface.dropTable('Subtarefas'); }
};