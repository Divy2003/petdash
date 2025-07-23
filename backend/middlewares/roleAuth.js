const User = require('../models/User');

// Middleware to check if user has specific role access
const requireRole = (allowedRoles) => {
  return async (req, res, next) => {
    try {
      if (!req.user) {
        return res.status(401).json({ message: 'Authentication required' });
      }

      // Get current user from database to ensure we have latest role information
      const user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      const currentRole = user.currentRole || user.userType;
      
      // Convert single role to array for consistency
      const rolesArray = Array.isArray(allowedRoles) ? allowedRoles : [allowedRoles];
      
      // Check if user's current role is in allowed roles
      if (!rolesArray.includes(currentRole)) {
        return res.status(403).json({ 
          message: `Access denied. Required role: ${rolesArray.join(' or ')}. Current role: ${currentRole}`,
          currentRole: currentRole,
          requiredRoles: rolesArray
        });
      }

      // Update req.user with current role information
      req.user.currentRole = currentRole;
      req.user.availableRoles = user.availableRoles || [user.userType];
      
      next();
    } catch (error) {
      console.error('Role authorization error:', error);
      res.status(500).json({ message: 'Authorization check failed', error: error.message });
    }
  };
};

// Specific role middleware functions
const requirePetOwner = requireRole('Pet Owner');
const requireBusiness = requireRole('Business');
const requireAdmin = requireRole('Admin');
const requirePetOwnerOrBusiness = requireRole(['Pet Owner', 'Business']);

// Middleware to check if user can access business features
const requireBusinessAccess = async (req, res, next) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const currentRole = user.currentRole || user.userType;
    
    // Allow access if current role is Business or if user has Business in available roles
    if (currentRole === 'Business' || user.availableRoles.includes('Business')) {
      req.user.currentRole = currentRole;
      req.user.availableRoles = user.availableRoles || [user.userType];
      return next();
    }

    return res.status(403).json({ 
      message: 'Business access required. Please switch to Business role or contact admin.',
      currentRole: currentRole,
      availableRoles: user.availableRoles
    });
  } catch (error) {
    console.error('Business access check error:', error);
    res.status(500).json({ message: 'Access check failed', error: error.message });
  }
};

// Middleware to check if user can access pet owner features
const requirePetOwnerAccess = async (req, res, next) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const currentRole = user.currentRole || user.userType;
    
    // Allow access if current role is Pet Owner or if user has Pet Owner in available roles
    if (currentRole === 'Pet Owner' || user.availableRoles.includes('Pet Owner')) {
      req.user.currentRole = currentRole;
      req.user.availableRoles = user.availableRoles || [user.userType];
      return next();
    }

    return res.status(403).json({ 
      message: 'Pet Owner access required. Please switch to Pet Owner role.',
      currentRole: currentRole,
      availableRoles: user.availableRoles
    });
  } catch (error) {
    console.error('Pet Owner access check error:', error);
    res.status(500).json({ message: 'Access check failed', error: error.message });
  }
};

// Middleware to update user context with current role
const updateUserContext = async (req, res, next) => {
  try {
    if (req.user && req.user.id) {
      const user = await User.findById(req.user.id);
      if (user) {
        req.user.currentRole = user.currentRole || user.userType;
        req.user.availableRoles = user.availableRoles || [user.userType];
        req.user.userType = user.userType; // Ensure userType is always available
      }
    }
    next();
  } catch (error) {
    console.error('Update user context error:', error);
    next(); // Continue even if context update fails
  }
};

module.exports = {
  requireRole,
  requirePetOwner,
  requireBusiness,
  requireAdmin,
  requirePetOwnerOrBusiness,
  requireBusinessAccess,
  requirePetOwnerAccess,
  updateUserContext
};
