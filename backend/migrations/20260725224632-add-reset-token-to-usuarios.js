'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Usuarios', 'resetPasswordToken', {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn('Usuarios', 'resetPasswordExpires', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface, queryInterface_Sequelize) {
    await queryInterface.removeColumn('Usuarios', 'resetPasswordToken');
    await queryInterface.removeColumn('Usuarios', 'resetPasswordExpires');
  },
};