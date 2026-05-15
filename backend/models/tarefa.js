'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Tarefa extends Model {
    static associate(models) {

      this.belongsTo(models.Usuario, {
        foreignKey: 'usuarioId',
        as: 'usuario'
      });
      this.hasMany(models.Subtarefa, {
        foreignKey: 'tarefaId',
        as: 'subtarefas'
      });
    }
  }
  Tarefa.init({
    titulo: {
      type: DataTypes.STRING,
      allowNull: false
    },
    descricao: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    concluida: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    usuarioId: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Tarefa',
    tableName: 'Tarefas',
    paranoid: true,
  });
  return Tarefa;
};