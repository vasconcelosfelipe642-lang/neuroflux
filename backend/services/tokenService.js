'use strict';

const crypto = require('crypto');
const jwt = require('jsonwebtoken');

const ACCESS_TOKEN_EXPIRES_IN = process.env.ACCESS_TOKEN_EXPIRES_IN || '15m';
const REFRESH_TOKEN_EXPIRES_IN = process.env.REFRESH_TOKEN_EXPIRES_IN || '7d';
const REFRESH_TOKEN_EXPIRES_IN_MS = Number(process.env.REFRESH_TOKEN_EXPIRES_IN_MS)
  || 7 * 24 * 60 * 60 * 1000;

function getRequiredSecret(name) {
  const secret = process.env[name];
  if (!secret) {
    throw new Error(`${name} nao configurado nas variaveis de ambiente`);
  }
  return secret;
}

function getRefreshSecret() {
  return process.env.JWT_REFRESH_SECRET || getRequiredSecret('JWT_SECRET');
}

function buildUserPayload(usuario) {
  return {
    id: usuario.id,
    nome: usuario.nome,
    email: usuario.email,
    role: usuario.role,
  };
}

function generateAccessToken(usuario) {
  return jwt.sign(
    buildUserPayload(usuario),
    getRequiredSecret('JWT_SECRET'),
    { expiresIn: ACCESS_TOKEN_EXPIRES_IN },
  );
}

function generateRefreshToken(usuario) {
  return jwt.sign(
    { sub: usuario.id, type: 'refresh' },
    getRefreshSecret(),
    { expiresIn: REFRESH_TOKEN_EXPIRES_IN },
  );
}

function verifyAccessToken(token) {
  return jwt.verify(token, getRequiredSecret('JWT_SECRET'));
}

function verifyRefreshToken(token) {
  return jwt.verify(token, getRefreshSecret());
}

function hashRefreshToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

function getRefreshTokenExpiresAt() {
  return new Date(Date.now() + REFRESH_TOKEN_EXPIRES_IN_MS);
}

async function issueTokenPair(usuario) {
  const accessToken = generateAccessToken(usuario);
  const refreshToken = generateRefreshToken(usuario);

  await usuario.update({
    refreshTokenHash: hashRefreshToken(refreshToken),
    refreshTokenExpiresAt: getRefreshTokenExpiresAt(),
  });

  return {
    accessToken,
    refreshToken,
    expiresIn: ACCESS_TOKEN_EXPIRES_IN,
    refreshExpiresIn: REFRESH_TOKEN_EXPIRES_IN,
    user: buildUserPayload(usuario),
  };
}

module.exports = {
  ACCESS_TOKEN_EXPIRES_IN,
  REFRESH_TOKEN_EXPIRES_IN,
  generateAccessToken,
  generateRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
  hashRefreshToken,
  issueTokenPair,
};
