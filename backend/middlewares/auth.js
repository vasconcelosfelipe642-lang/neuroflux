'use strict';

const { verifyAccessToken } = require('../services/tokenService');
const { isAdminRole } = require('../constants/userRoles');

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.startsWith('Bearer ')
    ? authHeader.split(' ')[1]
    : null;

  if (!token) {
    return res.status(401).json({ message: 'Nao autorizado' });
  }

  try {
    req.user = verifyAccessToken(token);
    return next();
  } catch (error) {
    return res.status(401).json({ message: 'Token invalido ou expirado' });
  }
};

const isAdmin = (req, res, next) => {
  if (!req.user || !isAdminRole(req.user.role)) {
    return res.status(403).json({ message: 'Acesso negado. Apenas administradores.' });
  }

  return next();
};

module.exports = {
  verifyToken,
  isAdmin,
};
