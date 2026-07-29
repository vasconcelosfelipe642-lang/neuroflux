'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('Usuarios', 'role', {
      type: Sequelize.ENUM('admin', 'user', 'common', 'child', 'guardian'),
      allowNull: false,
      defaultValue: 'common',
    });

    await queryInterface.sequelize.query(
      "UPDATE `Usuarios` SET `role` = 'common' WHERE `role` = 'user';",
    );

    await queryInterface.changeColumn('Usuarios', 'role', {
      type: Sequelize.ENUM('common', 'child', 'guardian', 'admin'),
      allowNull: false,
      defaultValue: 'common',
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.changeColumn('Usuarios', 'role', {
      type: Sequelize.ENUM('admin', 'user', 'common', 'child', 'guardian'),
      allowNull: false,
      defaultValue: 'user',
    });

    await queryInterface.sequelize.query(
      "UPDATE `Usuarios` SET `role` = 'user' WHERE `role` IN ('common', 'child', 'guardian');",
    );

    await queryInterface.changeColumn('Usuarios', 'role', {
      type: Sequelize.ENUM('admin', 'user'),
      allowNull: false,
      defaultValue: 'user',
    });
  },
};
