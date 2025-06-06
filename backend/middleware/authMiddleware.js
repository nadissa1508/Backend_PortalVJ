const jwt = require('jsonwebtoken');
const { JWT_SECRET } = require('../config/config');

exports.authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) return res.status(401).json({ error: 'No token' });
  const token = authHeader.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token' });
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });
    req.user = {
      userId: user.id,
      role: user.rol,
      type: user.type
    };
    next();
  });
};
