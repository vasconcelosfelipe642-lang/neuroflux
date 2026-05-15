'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Subtarefa extends Model {
    static associate(models) {
      this.belongsTo(models.Tarefa, {
        foreignKey: 'tarefaId',
        as: 'tarefa'
      });
    }
  }
  Subtarefa.init({
    titulo: {
      type: DataTypes.STRING,
      allowNull: false
    },
    concluida: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    tarefaId: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Subtarefa',
    tableName: 'Subtarefas',
    paranoid: true,
  });
  return Subtarefa;
};
