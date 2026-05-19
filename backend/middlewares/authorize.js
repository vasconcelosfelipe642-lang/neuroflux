// Middleware genérico para verificar roles
module.exports = (allowedRoles) => {
  return (req, res, next) => {
    // req.user já foi preenchido pelo verifyToken
    if (!req.user) {
      return res.status(401).json({ message: 'Não autorizado' });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        message: 'Acesso negado. Permissão insuficiente.'
      });
    }

    next();
  };
};
