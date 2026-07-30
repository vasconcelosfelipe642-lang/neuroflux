'use strict';

require('dotenv').config();

const { Usuario, sequelize } = require('../models');
const { USER_ROLES } = require('../constants/userRoles');

function requireEnv(name) {
  const value = process.env[name];
  if (!value || !value.trim()) {
    throw new Error(`${name} nao configurado no .env`);
  }

  return value.trim();
}

async function createOrPromoteAdmin() {
  const email = requireEnv('ADMIN_EMAIL').toLowerCase();
  const nome = process.env.ADMIN_NAME?.trim() || 'Administrador NeuroFlux';
  const password = process.env.ADMIN_PASSWORD?.trim();
  const shouldResetPassword = process.env.ADMIN_RESET_PASSWORD === 'true';

  await sequelize.authenticate();

  const existingUser = await Usuario.findOne({ where: { email } });

  if (existingUser) {
    const payload = { role: USER_ROLES.ADMIN };

    if (shouldResetPassword) {
      if (!password) {
        throw new Error('ADMIN_PASSWORD obrigatorio quando ADMIN_RESET_PASSWORD=true');
      }

      payload.senha = password;
    }

    await existingUser.update(payload);

    console.log(`Usuario ${email} promovido para admin.`);
    if (shouldResetPassword) {
      console.log('Senha do admin atualizada.');
    }

    return;
  }

  if (!password) {
    throw new Error('ADMIN_PASSWORD obrigatorio para criar o primeiro admin');
  }

  await Usuario.create({
    nome,
    email,
    senha: password,
    role: USER_ROLES.ADMIN,
  });

  console.log(`Admin ${email} criado com sucesso.`);
}

createOrPromoteAdmin()
  .catch((error) => {
    console.error(`Erro ao criar admin: ${error.message}`);
    process.exitCode = 1;
  })
  .finally(async () => {
    await sequelize.close();
  });
