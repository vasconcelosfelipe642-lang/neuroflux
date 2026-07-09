'use strict';

const USER_ROLES = Object.freeze({
  COMMON: 'common',
  CHILD: 'child',
  GUARDIAN: 'guardian',
  ADMIN: 'admin',
});

const ROLE_VALUES = Object.freeze(Object.values(USER_ROLES));
const PUBLIC_SIGN_UP_ROLES = Object.freeze([
  USER_ROLES.COMMON,
  USER_ROLES.CHILD,
  USER_ROLES.GUARDIAN,
]);

const ROLE_ALIASES = Object.freeze({
  user: USER_ROLES.COMMON,
  comum: USER_ROLES.COMMON,
  crianca: USER_ROLES.CHILD,
  'crian\u00e7a': USER_ROLES.CHILD,
  responsavel: USER_ROLES.GUARDIAN,
  'respons\u00e1vel': USER_ROLES.GUARDIAN,
  adm: USER_ROLES.ADMIN,
});

function normalizeRole(role, fallback = USER_ROLES.COMMON) {
  if (!role) return fallback;
  const value = String(role).trim().toLowerCase();
  return ROLE_ALIASES[value] || value;
}

function isValidRole(role) {
  return ROLE_VALUES.includes(role);
}

function isPublicSignUpRole(role) {
  return PUBLIC_SIGN_UP_ROLES.includes(role);
}

function isAdminRole(role) {
  return normalizeRole(role) === USER_ROLES.ADMIN;
}

module.exports = {
  USER_ROLES,
  ROLE_VALUES,
  PUBLIC_SIGN_UP_ROLES,
  normalizeRole,
  isValidRole,
  isPublicSignUpRole,
  isAdminRole,
};
