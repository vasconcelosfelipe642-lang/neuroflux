'use strict';
const bcrypt = require('bcryptjs');
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Usuario extends Model {
    static associate(models) {
      this.hasMany(models.Tarefa, {
        foreignKey: 'usuarioId',
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
    paranoid: false,          
    timestamps: true,
    hooks: {
      beforeCreate: async (usuario) => {
        if (usuario.senha) {
          usuario.senha = await bcrypt.hash(usuario.senha, 10);
        }
      },
      beforeUpdate: async (usuario) => {
        if (usuario.changed('senha')) {
          usuario.senha = await bcrypt.hash(usuario.senha, 10);
        }
      }
    }
  });

  return Usuario;
};