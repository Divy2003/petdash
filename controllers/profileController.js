exports.getProfile = async (req, res) => {
  try {
    // req.user contains the decoded JWT data
    const { id, userType } = req.user;
    
    // Your profile logic here
    res.status(200).json({ 
      message: 'Profile fetched successfully',
      userId: id,
      userType
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching profile', error: error.message });
  }
};
