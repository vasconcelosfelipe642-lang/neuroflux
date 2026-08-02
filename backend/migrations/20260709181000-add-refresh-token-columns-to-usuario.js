'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Usuarios', 'refreshTokenHash', {
      type: Sequelize.STRING(64),
      allowNull: true,
    });

    await queryInterface.addColumn('Usuarios', 'refreshTokenExpiresAt', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Usuarios', 'refreshTokenExpiresAt');
    await queryInterface.removeColumn('Usuarios', 'refreshTokenHash');
  },
};
