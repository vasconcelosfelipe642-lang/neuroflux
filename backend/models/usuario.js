'use strict';

const bcrypt = require('bcryptjs');
const { Model } = require('sequelize');
const { ROLE_VALUES, USER_ROLES, normalizeRole } = require('../constants/userRoles');

module.exports = (sequelize, DataTypes) => {
  class Usuario extends Model {
    static associate(models) {
      this.hasMany(models.Tarefa, {
        foreignKey: 'usuarioId',
        as: 'tarefas',
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
        isEmail: true,
      },
    },
    role: {
      type: DataTypes.ENUM(...ROLE_VALUES),
      allowNull: false,
      defaultValue: USER_ROLES.COMMON,
    },
    senha: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    refreshTokenHash: {
      type: DataTypes.STRING(64),
      allowNull: true,
    },
    refreshTokenExpiresAt: {
      type: DataTypes.DATE,
      allowNull: true,
    },
  }, {
    sequelize,
    modelName: 'Usuario',
    tableName: 'Usuarios',
    paranoid: false,
    timestamps: true,
    hooks: {
      beforeCreate: async (usuario) => {
        usuario.role = normalizeRole(usuario.role);
        if (usuario.senha) {
          usuario.senha = await bcrypt.hash(usuario.senha, 10);
        }
      },
      beforeUpdate: async (usuario) => {
        if (usuario.changed('role')) {
          usuario.role = normalizeRole(usuario.role);
        }
        if (usuario.changed('senha')) {
          usuario.senha = await bcrypt.hash(usuario.senha, 10);
        }
      },
    },
  });

  return Usuario;
};
