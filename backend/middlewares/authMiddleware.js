const jwt = require('jsonwebtoken');
const db = require('../database_cn');
const JWT_SECRET = process.env.JWT_SECRET || 'portalvj-secret-2024';

const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ success: false, error: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    console.log('Token decoded successfully:', { id: decoded.id, role: decoded.rol });
    req.user = { id: decoded.id, role: decoded.rol, rol: decoded.rol }; // Attach user details to the request with both properties for compatibility
    next();
  } catch (error) {
    console.error('Token verification failed:', error.message);
    res.status(401).json({ success: false, error: 'Invalid token.' });
  }
};

const isAdmin = async (req, res, next) => {
    try {
        if (req.user.role === 'Administrativo') {
            next();
        } else {
            res.status(403).json({ error: 'Acceso denegado. Se requiere rol Administrativo' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Error al verificar permisos' });
    }
};

const isSup = async (req, res, next) => {
    try {
       if (req.user.role === 'SUP') {
            next();
        } else {
            console.log('Access denied - User role:', req.user.role, 'Required: SUP');
            res.status(403).json({ error: 'Acceso denegado. Se requiere rol Super Usuario' });
        }
    } catch (error) {
        console.error('Error verifying SUP permissions:', error);
        res.status(500).json({ error: 'Error al verificar permisos' });
    }
}

const isTeacher = (req, res, next) => {
    if (req.user.role === 'Maestro') {
      next();
    } else {
      res.status(403).json({ error: 'Acceso denegado. Se requiere rol Maestro' });
    }
  };

const isDirector = async (req, res, next) => {
    try {
        if (req.user.role === 'Director') {
            next();
        } else {
            res.status(403).json({ error: 'Acceso denegado. Se requiere rol Director' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Error al verificar permisos' });
    }
};

module.exports = {
    verifyToken,
    isAdmin,
    isSup,
    isTeacher,
    isDirector
};