import '../app_config/app_config.dart';

class ImageHelper {
  /// Constructs a proper image URL from a path stored in the database
  /// Handles both cases: paths with leading slash (/uploads/...) and without (uploads/...)
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Remove leading slash if present to avoid double slash
    String cleanPath = imagePath;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    // Construct the full URL
    return '${AppConfig.baseFileUrl}/$cleanPath';
  }

  /// Gets the first image URL from a list of image paths
  static String getFirstImageUrl(List<dynamic>? images) {
    if (images == null || images.isEmpty) {
      return '';
    }

    return getImageUrl(images.first.toString());
  }

  /// Validates if an image path is valid
  static bool isValidImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }

    // Check if it's a valid URL or path
    return imagePath.startsWith('http://') || 
           imagePath.startsWith('https://') || 
           imagePath.contains('uploads/');
  }

  /// Gets a placeholder image URL for different types
  static String getPlaceholderUrl(String type) {
    switch (type.toLowerCase()) {
      case 'service':
        return 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Service';
      case 'business':
        return 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Business';
      case 'pet':
        return 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Pet';
      case 'product':
        return 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Product';
      default:
        return 'https://via.placeholder.com/150x150/f8f9fa/6c757d?text=Image';
    }
  }
}
