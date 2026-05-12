'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Tarefa extends Model {
    static associate(models) {
      // Uma tarefa pertence a um usuário
      this.belongsTo(models.Usuario, {
        foreignKey: 'usuario_id',
        as: 'usuario'
      });
      // Uma tarefa pode ter muitas subtarefas
      this.hasMany(models.Subtarefa, {
        foreignKey: 'tarefa_id',
        as: 'subtarefas'
      });
    }
  }
  Tarefa.init({
    titulo: {
      type: DataTypes.STRING,
      allowNull: false
    },
    descricao: DataTypes.TEXT,
    concluida: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    usuario_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Tarefa',
    tableName: 'Tarefas'
  });
  return Tarefa;
};