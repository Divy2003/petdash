const Gallery = require('../models/Gallery');
const User = require('../models/User');

// Get gallery for business user
exports.getGallery = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user || user.userType !== 'Business') {
      return res.status(403).json({ message: 'Access denied' });
    }
    let gallery = await Gallery.findOne({ business: req.user.id });
    if (!gallery) {
      gallery = await Gallery.create({ business: req.user.id, images: [] });
    }
    res.status(200).json({ gallery });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching gallery', error: error.message });
  }
};

// Add images to gallery
exports.addImages = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user || user.userType !== 'Business') {
      return res.status(403).json({ message: 'Access denied' });
    }
    const imagePaths = req.files.map(file => {
      // Normalize path to use single backslashes and ensure it starts with \uploads\
      let normalizedPath = file.path.replace(/\\\\/g, '\\').replace(/\//g, '\\');
      if (!normalizedPath.startsWith('\\')) {
        normalizedPath = '\\' + normalizedPath;
      }
      return normalizedPath;
    });
    let gallery = await Gallery.findOne({ business: req.user.id });
    if (!gallery) {
      gallery = await Gallery.create({ business: req.user.id, images: imagePaths });
    } else {
      gallery.images.push(...imagePaths);
      await gallery.save();
    }
    res.status(200).json({ message: 'Images added', gallery });
  } catch (error) {
    res.status(500).json({ message: 'Error adding images', error: error.message });
  }
};

// Delete an image from gallery
exports.deleteImage = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user || user.userType !== 'Business') {
      return res.status(403).json({ message: 'Access denied' });
    }
    const { imagePath } = req.body;
    let gallery = await Gallery.findOne({ business: req.user.id });
    if (!gallery) {
      return res.status(404).json({ message: 'Gallery not found' });
    }
    gallery.images = gallery.images.filter(img => img !== imagePath);
    await gallery.save();
    res.status(200).json({ message: 'Image deleted', gallery });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting image', error: error.message });
  }
}; 