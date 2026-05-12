'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Subtarefa extends Model {
    static associate(models) {
      this.belongsTo(models.Tarefa, {
        foreignKey: 'tarefa_id',
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
    tarefa_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Subtarefa',
    tableName: 'Subtarefas'
  });
  return Subtarefa;
};