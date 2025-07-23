 const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');


exports.signup = async (req, res) => {
  try {
    const { name, email, password, userType } = req.body;

    // Validate required fields
    if (!name || !email || !password || !userType) {
      return res.status(400).json({
        message: 'All fields are required',
        error: 'Missing required fields: name, email, password, userType'
      });
    }

    // Validate userType
    const validUserTypes = ['Pet Owner', 'Business', 'Admin'];
    if (!validUserTypes.includes(userType)) {
      return res.status(400).json({
        message: 'Invalid user type',
        error: `userType must be one of: ${validUserTypes.join(', ')}`
      });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        message: 'User already exists',
        error: 'A user with this email address already exists'
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      userType
    });

    await newUser.save();

    res.status(201).json({
      message: 'User created successfully',
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        userType: newUser.userType,
        currentRole: newUser.currentRole,
        availableRoles: newUser.availableRoles
      }
    });

  } catch (err) {
    console.error('Signup error:', err);

    // Handle mongoose validation errors
    if (err.name === 'ValidationError') {
      const validationErrors = Object.values(err.errors).map(e => e.message);
      return res.status(400).json({
        message: 'Validation failed',
        error: validationErrors.join(', ')
      });
    }

    // Handle duplicate key errors
    if (err.code === 11000) {
      return res.status(400).json({
        message: 'User already exists',
        error: 'A user with this email address already exists'
      });
    }

    res.status(500).json({
      message: 'Signup failed',
      error: err.message
    });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email })
    if (!user) return res.status(400).json({ message: 'User not found' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Incorrect password' });

    // Include role information in JWT token
    const token = jwt.sign({
      id: user._id,
      userType: user.userType,
      currentRole: user.currentRole || user.userType,
      availableRoles: user.availableRoles || [user.userType]
    }, process.env.JWT_SECRET, {
      expiresIn: '1d'
    });

    // Remove password before sending user object in response
    const userResponse = user.toObject();
    delete userResponse.password;

    // Add role switching information to response
    userResponse.currentRole = user.currentRole || user.userType;
    userResponse.availableRoles = user.getAvailableRoles();
    userResponse.canSwitchRoles = user.userType !== 'Admin';

    res.status(200).json({
      message: 'Login successful',
      token,
      user: userResponse
    });
  } catch (err) {
    res.status(500).json({ message: 'Login failed', error: err.message });
  }
};


// Request password reset
exports.requestPasswordReset = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Generate 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    user.resetPasswordOTP = otp;
    user.resetPasswordOTPExpires = Date.now() + 600000; // 10 minutes
    await user.save();

    // Send email with nodemailer
    try {
      const nodemailer = require('nodemailer');
      // Configure your transporter (example using Gmail SMTP)
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: process.env.EMAIL_USER, // Add to your .env
          pass: process.env.EMAIL_PASS  // Add to your .env
        }
      });
      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'Password Reset OTP',
        text: `Your password reset OTP is: ${otp}. This OTP will expire in 10 minutes.`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2>Password Reset Request</h2>
            <p>You requested a password reset for your account.</p>
            <p>Your OTP is: <strong style="font-size: 24px; color: #007bff;">${otp}</strong></p>
            <p>This OTP will expire in 10 minutes.</p>
            <p>If you didn't request this, please ignore this email.</p>
          </div>
        `
      };
      await transporter.sendMail(mailOptions);
      console.log('Password reset OTP sent:', otp);
      res.status(200).json({ message: 'Password reset OTP sent to email' });
    } catch (mailErr) {
      // Fallback: log the OTP if email fails
      console.log('Password reset OTP (email failed):', otp);
      res.status(200).json({ message: 'Password reset OTP (email failed, see server log)', otp });
    }
  } catch (err) {
    res.status(500).json({ message: 'Failed to request password reset', error: err.message });
  }
};

// Verify OTP
exports.verifyOTP = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const user = await User.findOne({
      email,
      resetPasswordOTP: otp,
      resetPasswordOTPExpires: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    res.status(200).json({ message: 'OTP verified successfully', verified: true });
  } catch (err) {
    res.status(500).json({ message: 'Failed to verify OTP', error: err.message });
  }
};

// Reset password with OTP
exports.resetPassword = async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body;
    const user = await User.findOne({
      email,
      resetPasswordOTP: otp,
      resetPasswordOTPExpires: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    user.resetPasswordOTP = undefined;
    user.resetPasswordOTPExpires = undefined;
    // Keep the old token fields for backward compatibility if needed
    user.resetPasswordToken = undefined;
    user.resetPasswordExpires = undefined;
    await user.save();

    res.status(200).json({ message: 'Password has been reset successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Failed to reset password', error: err.message });
  }
};

// Switch user role
exports.switchRole = async (req, res) => {
  try {
    const { newRole } = req.body;
    const userId = req.user.id;

    if (!newRole) {
      return res.status(400).json({ message: 'New role is required' });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Check if user can switch to this role
    if (!user.canSwitchToRole(newRole)) {
      return res.status(403).json({
        message: 'You do not have permission to switch to this role',
        availableRoles: user.getAvailableRoles()
      });
    }

    // Switch the role
    await user.switchRole(newRole);

    // Generate new token with updated role information
    const token = jwt.sign({
      id: user._id,
      userType: user.userType,
      currentRole: user.currentRole,
      availableRoles: user.availableRoles
    }, process.env.JWT_SECRET, {
      expiresIn: '1d'
    });

    // Prepare user response
    const userResponse = user.toObject();
    delete userResponse.password;
    userResponse.availableRoles = user.getAvailableRoles();
    userResponse.canSwitchRoles = user.userType !== 'Admin';

    res.status(200).json({
      message: `Successfully switched to ${newRole} role`,
      token,
      user: userResponse,
      previousRole: req.user.currentRole || req.user.userType
    });
  } catch (err) {
    res.status(500).json({
      message: 'Failed to switch role',
      error: err.message
    });
  }
};

// Get current user role information
exports.getRoleInfo = async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId).select('-password');

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      message: 'Role information retrieved successfully',
      roleInfo: {
        userType: user.userType,
        currentRole: user.currentRole || user.userType,
        availableRoles: user.getAvailableRoles(),
        canSwitchRoles: user.userType !== 'Admin',
        roleHistory: user.roleHistory.slice(-5) // Last 5 role switches
      }
    });
  } catch (err) {
    res.status(500).json({
      message: 'Failed to get role information',
      error: err.message
    });
  }
};

// Enable role switching for a user (admin function)
exports.enableRoleSwitching = async (req, res) => {
  try {
    const { userId, rolesToEnable } = req.body;

    // Check if current user is admin
    const currentRole = req.user.currentRole || req.user.userType;
    if (currentRole !== 'Admin' && req.user.userType !== 'Admin') {
      return res.status(403).json({ message: 'Only admins can enable role switching' });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (user.userType === 'Admin') {
      return res.status(400).json({ message: 'Cannot enable role switching for admin users' });
    }

    // Validate roles
    const validRoles = ['Pet Owner', 'Business'];
    const invalidRoles = rolesToEnable.filter(role => !validRoles.includes(role));
    if (invalidRoles.length > 0) {
      return res.status(400).json({
        message: 'Invalid roles provided',
        invalidRoles
      });
    }

    // Update available roles
    user.availableRoles = [...new Set([...user.availableRoles, ...rolesToEnable])];
    await user.save();

    res.status(200).json({
      message: 'Role switching enabled successfully',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        userType: user.userType,
        currentRole: user.currentRole,
        availableRoles: user.availableRoles
      }
    });
  } catch (err) {
    res.status(500).json({
      message: 'Failed to enable role switching',
      error: err.message
    });
  }
};


