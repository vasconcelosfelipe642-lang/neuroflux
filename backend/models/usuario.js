'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Usuario extends Model {
    static associate(models) {
      this.hasMany(models.Tarefa, {
        foreignKey: 'usuario_id',
        as: 'tarefas'
      });
    }
  }
  Usuario.init({
    nome: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true 
      }
    },
    role:{
   type: DataTypes.ENUM('admin', 'user'),
    defaultValue: 'user'
    },
    senha: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Usuario',    
    tableName: 'Usuarios',  
    paranoid: true,          
    timestamps: true        
  });

  return Usuario;
};