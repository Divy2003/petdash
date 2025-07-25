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
            <div className="category-modal-section">
              <h4 className="category-modal-section-title">Basic Information</h4>

              <div className="category-modal-meta-grid">
                <div>
                  <label className="category-modal-label">Name *</label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    className="category-modal-input"
                    placeholder="e.g., Pet Sitting"
                    required
                  />
                </div>
                <div>
                  <label className="category-modal-label">Short Description</label>
                  <input
                    type="text"
                    name="shortDescription"
                    value={formData.shortDescription}
                    onChange={handleChange}
                    className="category-modal-input"
                    placeholder="Brief one-liner"
                    maxLength={100}
                  />
                </div>
              </div>

              <div>
                <label className="category-modal-label">Description *</label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  className="category-modal-textarea"
                  rows={3}
                  placeholder="Detailed description of this category"
                  required
                />
              </div>
            </div>

            {/* Visual Elements */}
            <div className="category-modal-section">
              <h4 className="category-modal-section-title">Visual Elements</h4>

              <div>
                <label className="category-modal-label">Icon</label>
                <div className="space-y-3">
                  <input
                    type="text"
                    name="icon"
                    value={formData.icon}
                    onChange={handleChange}
                    className="category-modal-input"
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

              <div className="category-modal-meta-grid">
                <div>
                  <label className="category-modal-label">Background Color</label>
                  <input
                    type="color"
                    name="color"
                    value={formData.color}
                    onChange={handleChange}
                    className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                  />
                </div>
                <div>
                  <label className="category-modal-label">Text Color</label>
                  <input
                    type="color"
                    name="textColor"
                    value={formData.textColor}
                    onChange={handleChange}
                    className="w-full h-10 border border-gray-300 rounded-lg cursor-pointer"
                  />
                </div>
              </div>

              <div className="category-modal-meta-grid">
                <div>
                  <label className="category-modal-label">Category Image</label>
                  <div className="category-modal-tags-list">
                    {imagePreview ? (
                      <div className="category-modal-image-relative">
                        <img
                          src={imagePreview}
                          alt="Category preview"
                          className="category-modal-image-preview"
                          onError={(e) => handleImageError(e, 'category')}
                        />
                        <button
                          type="button"
                          onClick={() => removeImage('main')}
                          className="category-modal-remove-image-btn"
                        >
                          <FiX className="w-4 h-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="category-modal-upload-box">
                        <input
                          type="file"
                          accept="image/*"
                          onChange={(e) => handleImageUpload(e.target.files[0], 'main')}
                          className="category-modal-upload-input"
                          id="main-image-upload"
                        />
                        <label
                          htmlFor="main-image-upload"
                          className="category-modal-upload-label"
                        >
                          <div className="category-modal-upload-icon">📷</div>
                          <div className="category-modal-upload-text">Click to upload image</div>
                        </label>
                      </div>
                    )}
                    <input
                      type="url"
                      name="image"
                      value={formData.image}
                      onChange={handleChange}
                      className="category-modal-input"
                      placeholder="Or enter image URL"
                    />
                  </div>
                </div>

                <div>
                  <label className="category-modal-label">Thumbnail Image</label>
                  <div className="category-modal-tags-list">
                    {thumbnailPreview ? (
                      <div className="category-modal-image-relative">
                        <img
                          src={thumbnailPreview}
                          alt="Thumbnail preview"
                          className="category-modal-image-preview"
                          onError={(e) => handleImageError(e, 'category')}
                        />
                        <button
                          type="button"
                          onClick={() => removeImage('thumbnail')}
                          className="category-modal-remove-image-btn"
                        >
                          <FiX className="w-4 h-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="category-modal-upload-box">
                        <input
                          type="file"
                          accept="image/*"
                          onChange={(e) => handleImageUpload(e.target.files[0], 'thumbnail')}
                          className="category-modal-upload-input"
                          id="thumbnail-image-upload"
                        />
                        <label
                          htmlFor="thumbnail-image-upload"
                          className="category-modal-upload-label"
                        >
                          <div className="category-modal-upload-icon">🖼️</div>
                          <div className="category-modal-upload-text">Click to upload thumbnail</div>
                        </label>
                      </div>
                    )}
                    <input
                      type="url"
                      name="thumbnailImage"
                      value={formData.thumbnailImage}
                      onChange={handleChange}
                      className="category-modal-input"
                      placeholder="Or enter thumbnail URL"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="category-modal-section">
              <h4 className="category-modal-section-title">Settings</h4>

              <div className="category-modal-settings-grid">
                <div>
                  <label className="category-modal-label">Display Order</label>
                  <input
                    type="number"
                    name="order"
                    value={formData.order}
                    onChange={handleChange}
                    className="category-modal-input"
                    min="0"
                    placeholder="0"
                  />
                </div>
                <div className="category-modal-setting-row">
                  <label className="category-modal-tag-row">
                    <input
                      type="checkbox"
                      name="isActive"
                      checked={formData.isActive}
                      onChange={handleChange}
                      className="category-modal-checkbox"
                    />
                    <span className="text-sm font-medium">Active Category</span>
                  </label>
                </div>
                <div className="category-modal-setting-row">
                  <label className="category-modal-tag-row">
                    <input
                      type="checkbox"
                      name="isFeatured"
                      checked={formData.isFeatured}
                      onChange={handleChange}
                      className="category-modal-checkbox"
                    />
                    <span className="text-sm font-medium">Featured Category</span>
                  </label>
                </div>
              </div>
            </div>

            <div className="category-modal-section">
              <h4 className="category-modal-section-title">SEO & Metadata</h4>

              <div className="category-modal-meta-grid">
                <div>
                  <label className="category-modal-label">Meta Title</label>
                  <input
                    type="text"
                    name="metaTitle"
                    value={formData.metaTitle}
                    onChange={handleChange}
                    className="category-modal-input"
                    placeholder="SEO title (max 60 chars)"
                    maxLength={60}
                  />
                </div>
                <div>
                  <label className="category-modal-label">Meta Description</label>
                  <textarea
                    name="metaDescription"
                    value={formData.metaDescription}
                    onChange={handleChange}
                    className="category-modal-textarea"
                    rows={2}
                    placeholder="SEO description (max 160 chars)"
                    maxLength={160}
                  />
                </div>
              </div>

              <div>
                <label className="category-modal-label">Tags</label>
                <div className="category-modal-tags-list">
                  {formData.tags.map((tag, index) => (
                    <div key={index} className="category-modal-tag-row">
                      <input
                        type="text"
                        value={tag}
                        onChange={(e) => handleTagChange(index, e.target.value)}
                        className="category-modal-tag-input"
                        placeholder="Enter tag"
                      />
                      {formData.tags.length > 1 && (
                        <button
                          type="button"
                          onClick={() => removeTag(index)}
                          className="category-modal-btn-remove-tag"
                        >
                          <FiMinus className="w-4 h-4" />
                        </button>
                      )}
                    </div>
                  ))}
                  <button
                    type="button"
                    onClick={addTag}
                    className="category-modal-btn-add-tag"
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
        <div className="category-modal-footer">
          <button
            onClick={handleSubmit}
            disabled={loading}
            className="category-modal-btn-primary"
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
            className="category-modal-btn-secondary"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};
export default CategoryFormModal;
