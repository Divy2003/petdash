const jwt = require('jsonwebtoken');

const auth = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({ message: 'Authentication required - No token provided' });
    }

    if (!process.env.JWT_SECRET) {
      console.error('JWT_SECRET not configured');
      return res.status(500).json({ message: 'Server configuration error' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Ensure backward compatibility and add role information
    req.user = {
      ...decoded,
      currentRole: decoded.currentRole || decoded.userType,
      availableRoles: decoded.availableRoles || [decoded.userType]
    };

    next();
  } catch (error) {
    console.error('Auth middleware error:', error.message);
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token expired' });
    } else if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ message: 'Invalid token format' });
    }
    res.status(401).json({ message: 'Invalid token', error: error.message });
  }
};

module.exports = auth;
