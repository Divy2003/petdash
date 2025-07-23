/**
 * Utility functions for handling image URLs
 */

// Base URL for the backend server
const BASE_URL = 'http://localhost:5000';

/**
 * Get the full URL for an image
 * @param {string} imagePath - The image path from the database
 * @returns {string} - The full URL to the image
 */
export const getImageUrl = (imagePath) => {
  if (!imagePath) return null;
  
  // If it's already a full URL, return as is
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath;
  }
  
  // If it starts with /uploads, prepend the base URL
  if (imagePath.startsWith('/uploads/')) {
    return `${BASE_URL}${imagePath}`;
  }
  
  // If it's just a filename, assume it's in uploads
  if (!imagePath.startsWith('/')) {
    return `${BASE_URL}/uploads/${imagePath}`;
  }
  
  // Default case - prepend base URL
  return `${BASE_URL}${imagePath}`;
};

/**
 * Get a placeholder image URL
 * @param {string} type - The type of placeholder (category, pet, etc.)
 * @returns {string} - The placeholder image URL
 */
export const getPlaceholderImage = (type = 'default') => {
  const placeholders = {
    category: 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Category',
    pet: 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Pet',
    user: 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=User',
    default: 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Image'
  };
  
  return placeholders[type] || placeholders.default;
};

/**
 * Handle image load errors by setting a placeholder
 * @param {Event} event - The error event
 * @param {string} type - The type of placeholder to use
 */
export const handleImageError = (event, type = 'default') => {
  event.target.src = getPlaceholderImage(type);
  event.target.onerror = null; // Prevent infinite loop
};
