import { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FiX, FiPlus, FiMinus } from 'react-icons/fi';
import { toast } from 'react-hot-toast';
import { closeCategoryForm } from '../../redux/slices/categoriesSlice';
import { createCategory, updateCategory } from '../../redux/slices/categoriesSlice';
import { getImageUrl, handleImageError } from '../../utils/imageUtils';
import './CategoryFormModal.css';

const CategoryFormModal = () => {
  const dispatch = useDispatch();
  const { categoryForm, loading } = useSelector((state) => state.categories);
  const { isOpen, mode, data } = categoryForm;

  // Predefined icons for quick selection
  const predefinedIcons = [
    '🐕', '🐱', '🐾', '🏥', '✂️', '🛁', '🎓', '🏃', '🍖', '🧸',
    '🚗', '🏠', '💊', '🩺', '🦴', '🎾', '🥎', '🪀', '🎪', '🎭'
  ];

  const [formData, setFormData] = useState({
    name: '',
    description: '',
    shortDescription: '',
    icon: '',
    image: '',
    thumbnailImage: '',
    color: '#f8f9fa',
    textColor: '#ffffff',
    order: 0,
    isActive: true,
    isFeatured: false,
    metaTitle: '',
    metaDescription: '',
    tags: [''],
  });

  const [imagePreview, setImagePreview] = useState(null);
  const [thumbnailPreview, setThumbnailPreview] = useState(null);
  const [uploadingImage, setUploadingImage] = useState(false);

  useEffect(() => {
    if (mode === 'edit' && data) {
      setFormData({
        name: data.name || '',
        description: data.description || '',
        shortDescription: data.shortDescription || '',
        icon: data.icon || '',
        image: data.image || '',
        thumbnailImage: data.thumbnailImage || '',
        color: data.color || '#f8f9fa',
        textColor: data.textColor || '#ffffff',
        order: data.order || 0,
        isActive: data.isActive !== undefined ? data.isActive : true,
        isFeatured: data.isFeatured || false,
        metaTitle: data.metaTitle || '',
        metaDescription: data.metaDescription || '',
        tags: data.tags || [''],
      });
      setImagePreview(data.image ? getImageUrl(data.image) : null);
      setThumbnailPreview(data.thumbnailImage ? getImageUrl(data.thumbnailImage) : null);
    } else {
      // Reset form for create mode
      setFormData({
        name: '',
        description: '',
        shortDescription: '',
        icon: '',
        image: '',
        thumbnailImage: '',
        color: '#f8f9fa',
        textColor: '#ffffff',
        order: 0,
        isActive: true,
        isFeatured: false,
        metaTitle: '',
        metaDescription: '',
        tags: [''],
      });
      setImagePreview(null);
      setThumbnailPreview(null);
    }
  }, [mode, data]);

  const predefinedColors = [
    '#f8f9fa', '#e8f5e8', '#e8f0ff', '#ffe8e8', '#fff8e8', 
    '#f8e8ff', '#e8fff8', '#ffe8f8', '#f0f8ff', '#fff5ee'
  ];

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleArrayChange = (field, index, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: prev[field].map((item, i) => i === index ? value : item)
    }));
  };

  const addArrayItem = (field) => {
    setFormData(prev => ({
      ...prev,
      [field]: [...prev[field], '']
    }));
  };

  const removeArrayItem = (field, index) => {
    setFormData(prev => ({
      ...prev,
      [field]: prev[field].filter((_, i) => i !== index)
    }));
  };

  const handleImageUpload = async (file, type) => {
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith('image/')) {
      toast.error('Please select a valid image file');
      return;
    }

    // Validate file size (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      toast.error('Image size should be less than 5MB');
      return;
    }

    setUploadingImage(true);

    try {
      if (type === 'main') {
        setFormData(prev => ({ ...prev, image: file }));
        const reader = new FileReader();
        reader.onload = (e) => setImagePreview(e.target.result);
        reader.readAsDataURL(file);
      } else if (type === 'thumbnail') {
        setFormData(prev => ({ ...prev, thumbnailImage: file }));
        const reader = new FileReader();
        reader.onload = (e) => setThumbnailPreview(e.target.result);
        reader.readAsDataURL(file);
      }
      toast.success('Image selected');
    } catch (error) {
      toast.error('Failed to process image');
      console.error('Image upload error:', error);
    } finally {
      setUploadingImage(false);
    }
  };

  const removeImage = (type) => {
    if (type === 'main') {
      setFormData(prev => ({ ...prev, image: '' }));
      setImagePreview(null);
    } else if (type === 'thumbnail') {
      setFormData(prev => ({ ...prev, thumbnailImage: '' }));
      setThumbnailPreview(null);
    }
  };

  const handleTagChange = (index, value) => {
    setFormData(prev => ({
      ...prev,
      tags: prev.tags.map((tag, i) => i === index ? value : tag)
    }));
  };

  const addTag = () => {
    setFormData(prev => ({
      ...prev,
      tags: [...prev.tags, '']
    }));
  };

  const removeTag = (index) => {
    setFormData(prev => ({
      ...prev,
      tags: prev.tags.filter((_, i) => i !== index)
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!formData.name || !formData.description) {
      toast.error('Please fill in all required fields');
      return;
    }

    try {
      const categoryData = {
        ...formData,
        order: parseInt(formData.order) || 0,
        tags: formData.tags.filter(tag => tag.trim() !== ''),
      };

      // Remove previews, only send File object
      if (typeof categoryData.image === 'string') delete categoryData.image;
      if (typeof categoryData.thumbnailImage === 'string') delete categoryData.thumbnailImage;

      if (mode === 'edit') {
        await dispatch(updateCategory({ id: data._id, data: categoryData })).unwrap();
        toast.success('Category updated successfully');
      } else {
        await dispatch(createCategory(categoryData)).unwrap();
        toast.success('Category created successfully');
      }

      dispatch(closeCategoryForm());
    } catch (error) {
      toast.error(error || 'Failed to save category');
    }
  };

  const handleClose = () => {
    dispatch(closeCategoryForm());
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-container" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="modal-header">
          <h3 className="modal-title">
            {mode === 'edit' ? 'Edit Category' : 'Create New Category'}
          </h3>
          <button
            onClick={handleClose}
            className="modal-close-btn"
            type="button"
          >
            <FiX size={20} />
          </button>
        </div>

        {/* Body */}
        <div className="modal-body">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Basic Information */}
            <div className="space-y-4">
              <h4 className="text-md font-semibold text-gray-900 border-b pb-2">Basic Information</h4>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="form-label">Name *</label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    className="form-input"
                    placeholder="e.g., Pet Sitting"
                    required
                  />
                </div>
                <div>
                  <label className="form-label">Short Description</label>
                  <input
                    type="text"
                    name="shortDescription"
                    value={formData.shortDescription}
                    onChange={handleChange}
                    className="form-input"
                    placeholder="Brief one-liner"
                    maxLength={100}
                  />
                </div>
              </div>

              <div>
                <label className="form-label">Description *</label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  className="form-textarea"
                  rows={3}
                  placeholder="Detailed description of this category"
                  required
                />
              </div>
            </div>

            {/* Visual Elements */}
            <div className="space-y-4">
              <h4 className="text-md font-semibold text-gray-900 border-b pb-2">Visual Elements</h4>

              <div>
                <label className="form-label">Icon</label>
                <div className="space-y-3">
                  <input
                    type="text"
                    name="icon"
                    value={formData.icon}
                    onChange={handleChange}
                    className="form-input"
                    placeholder="Enter emoji or icon"
                  />
                  <div className="grid grid-cols-10 gap-2">
                    {predefinedIcons.map((icon, index) => (
                      <button
                        key={index}
                        type="button"
                        onClick={() => setFormData(prev => ({ ...prev, icon }))}
                        className={`p-2 text-lg border rounded-lg hover:bg-gray-100 transition-colors ${
                          formData.icon === icon ? 'border-blue-500 bg-blue-50' : 'border-gray-300'
                        }`}
                      >
                        {icon}
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="form-label">Background Color</label>
                  <input
                    type="color"
                    name="color"
                    value={formData.color}
                    onChange={handleChange}
                    className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                  />
                </div>
                <div>
                  <label className="form-label">Text Color</label>
                  <input
                    type="color"
                    name="textColor"
                    value={formData.textColor}
                    onChange={handleChange}
                    className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="form-label">Category Image</label>
                  <div className="space-y-2">
                    {imagePreview ? (
                      <div className="relative">
                        <img
                          src={imagePreview}
                          alt="Category preview"
                          className="w-full h-32 object-cover rounded-lg border"
                          onError={(e) => handleImageError(e, 'category')}
                        />
                        <button
                          type="button"
                          onClick={() => removeImage('main')}
                          className="absolute top-2 right-2 p-1 bg-red-500 text-white rounded-full hover:bg-red-600"
                        >
                          <FiX className="w-4 h-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center">
                        <input
                          type="file"
                          accept="image/*"
                          onChange={(e) => handleImageUpload(e.target.files[0], 'main')}
                          className="hidden"
                          id="main-image-upload"
                        />
                        <label
                          htmlFor="main-image-upload"
                          className="cursor-pointer text-gray-500 hover:text-gray-700"
                        >
                          <div className="text-2xl mb-2">📷</div>
                          <div className="text-sm">Click to upload image</div>
                        </label>
                      </div>
                    )}
                    <input
                      type="url"
                      name="image"
                      value={formData.image}
                      onChange={handleChange}
                      className="form-input"
                      placeholder="Or enter image URL"
                    />
                  </div>
                </div>

                <div>
                  <label className="form-label">Thumbnail Image</label>
                  <div className="space-y-2">
                    {thumbnailPreview ? (
                      <div className="relative">
                        <img
                          src={thumbnailPreview}
                          alt="Thumbnail preview"
                          className="w-full h-32 object-cover rounded-lg border"
                          onError={(e) => handleImageError(e, 'category')}
                        />
                        <button
                          type="button"
                          onClick={() => removeImage('thumbnail')}
                          className="absolute top-2 right-2 p-1 bg-red-500 text-white rounded-full hover:bg-red-600"
                        >
                          <FiX className="w-4 h-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center">
                        <input
                          type="file"
                          accept="image/*"
                          onChange={(e) => handleImageUpload(e.target.files[0], 'thumbnail')}
                          className="hidden"
                          id="thumbnail-image-upload"
                        />
                        <label
                          htmlFor="thumbnail-image-upload"
                          className="cursor-pointer text-gray-500 hover:text-gray-700"
                        >
                          <div className="text-2xl mb-2">🖼️</div>
                          <div className="text-sm">Click to upload thumbnail</div>
                        </label>
                      </div>
                    )}
                    <input
                      type="url"
                      name="thumbnailImage"
                      value={formData.thumbnailImage}
                      onChange={handleChange}
                      className="form-input"
                      placeholder="Or enter thumbnail URL"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="space-y-4">
              <h4 className="text-md font-semibold text-gray-900 border-b pb-2">Settings</h4>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="form-label">Display Order</label>
                  <input
                    type="number"
                    name="order"
                    value={formData.order}
                    onChange={handleChange}
                    className="form-input"
                    min="0"
                    placeholder="0"
                  />
                </div>
                <div className="flex items-center justify-center">
                  <label className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      name="isActive"
                      checked={formData.isActive}
                      onChange={handleChange}
                      className="rounded"
                    />
                    <span className="text-sm font-medium">Active Category</span>
                  </label>
                </div>
                <div className="flex items-center justify-center">
                  <label className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      name="isFeatured"
                      checked={formData.isFeatured}
                      onChange={handleChange}
                      className="rounded"
                    />
                    <span className="text-sm font-medium">Featured Category</span>
                  </label>
                </div>
              </div>
            </div>

            <div className="space-y-4">
              <h4 className="text-md font-semibold text-gray-900 border-b pb-2">SEO & Metadata</h4>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="form-label">Meta Title</label>
                  <input
                    type="text"
                    name="metaTitle"
                    value={formData.metaTitle}
                    onChange={handleChange}
                    className="form-input"
                    placeholder="SEO title (max 60 chars)"
                    maxLength={60}
                  />
                </div>
                <div>
                  <label className="form-label">Meta Description</label>
                  <textarea
                    name="metaDescription"
                    value={formData.metaDescription}
                    onChange={handleChange}
                    className="form-textarea"
                    rows={2}
                    placeholder="SEO description (max 160 chars)"
                    maxLength={160}
                  />
                </div>
              </div>

              <div>
                <label className="form-label">Tags</label>
                <div className="space-y-2">
                  {formData.tags.map((tag, index) => (
                    <div key={index} className="flex items-center space-x-2">
                      <input
                        type="text"
                        value={tag}
                        onChange={(e) => handleTagChange(index, e.target.value)}
                        className="form-input flex-1"
                        placeholder="Enter tag"
                      />
                      {formData.tags.length > 1 && (
                        <button
                          type="button"
                          onClick={() => removeTag(index)}
                          className="p-2 text-red-500 hover:text-red-700"
                        >
                          <FiMinus className="w-4 h-4" />
                        </button>
                      )}
                    </div>
                  ))}
                  <button
                    type="button"
                    onClick={addTag}
                    className="text-sm text-blue-600 hover:text-blue-800"
                  >
                    <FiPlus className="w-4 h-4 inline mr-1" />
                    Add Tag
                  </button>
                </div>
              </div>
            </div>
          </form>
        </div>

        {/* Footer */}
        <div className="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
          <button
            onClick={handleSubmit}
            disabled={loading}
            className="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? (
              <div className="flex items-center">
                <div className="spinner mr-2"></div>
                {mode === 'edit' ? 'Updating...' : 'Creating...'}
              </div>
            ) : (
              mode === 'edit' ? 'Update Category' : 'Create Category'
            )}
          </button>
          <button
            onClick={handleClose}
            disabled={loading}
            className="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};
export default CategoryFormModal;
