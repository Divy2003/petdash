import { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FiX } from 'react-icons/fi';
import { toast } from 'react-hot-toast';
import { closeCourseForm } from '../../redux/slices/coursesSlice';
import { createCourse, updateCourse } from '../../redux/slices/coursesSlice';

const CourseFormModal = () => {
  const dispatch = useDispatch();
  const { courseForm, loading } = useSelector((state) => state.courses);
  const { isOpen, mode, data } = courseForm;

  const [formData, setFormData] = useState({
    title: '',
    description: '',
    shortDescription: '',
    category: 'Puppy Basics',
    difficulty: 'Beginner',
    difficultyLevel: 1,
    price: 0,
    originalPrice: 0,
    duration: 0,
    estimatedCompletionTime: '',
    coverImage: '',
    trainingType: 'online',
    learningObjectives: [''],
    tags: [''],
    isFeatured: false,
    isPopular: false,
  });

  useEffect(() => {
    if (mode === 'edit' && data) {
      setFormData({
        title: data.title || '',
        description: data.description || '',
        shortDescription: data.shortDescription || '',
        category: data.category || 'Puppy Basics',
        difficulty: data.difficulty || 'Beginner',
        difficultyLevel: data.difficultyLevel || 1,
        price: data.price || 0,
        originalPrice: data.originalPrice || 0,
        duration: data.duration || 0,
        estimatedCompletionTime: data.estimatedCompletionTime || '',
        coverImage: data.coverImage || '',
        trainingType: data.trainingType || 'online',
        learningObjectives: data.learningObjectives || [''],
        tags: data.tags || [''],
        isFeatured: data.isFeatured || false,
        isPopular: data.isPopular || false,
      });
    } else {
      // Reset form for create mode
      setFormData({
        title: '',
        description: '',
        shortDescription: '',
        category: 'Puppy Basics',
        difficulty: 'Beginner',
        difficultyLevel: 1,
        price: 0,
        originalPrice: 0,
        duration: 0,
        estimatedCompletionTime: '',
        coverImage: '',
        trainingType: 'online',
        learningObjectives: [''],
        tags: [''],
        isFeatured: false,
        isPopular: false,
      });
    }
  }, [mode, data]);

  const categories = [
    'Puppy Basics',
    'Adult Basics',
    'Grooming',
    'Sitting',
    'Fetch',
    'Stay',
    'Shake',
    'Leash Training',
    'Re-enforcement'
  ];

  const difficulties = ['Beginner', 'Intermediate', 'Advanced'];

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

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!formData.title || !formData.description) {
      toast.error('Please fill in all required fields');
      return;
    }

    try {
      const courseData = {
        ...formData,
        learningObjectives: formData.learningObjectives.filter(obj => obj.trim()),
        tags: formData.tags.filter(tag => tag.trim()),
        price: parseFloat(formData.price),
        originalPrice: parseFloat(formData.originalPrice),
        duration: parseInt(formData.duration),
        difficultyLevel: parseInt(formData.difficultyLevel),
      };

      if (mode === 'edit') {
        await dispatch(updateCourse({ id: data._id, data: courseData })).unwrap();
        toast.success('Course updated successfully');
      } else {
        await dispatch(createCourse(courseData)).unwrap();
        toast.success('Course created successfully');
      }
      
      dispatch(closeCourseForm());
    } catch (error) {
      toast.error(error || 'Failed to save course');
    }
  };

  const handleClose = () => {
    dispatch(closeCourseForm());
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        {/* Background overlay */}
        <div
          className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
          onClick={handleClose}
        />

        {/* Modal */}
        <div className="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-4xl sm:w-full">
          {/* Header */}
          <div className="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-medium text-gray-900">
                {mode === 'edit' ? 'Edit Course' : 'Create New Course'}
              </h3>
              <button
                onClick={handleClose}
                className="text-gray-400 hover:text-gray-600"
              >
                <FiX className="w-6 h-6" />
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Basic Information */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="form-label">Title *</label>
                  <input
                    type="text"
                    name="title"
                    value={formData.title}
                    onChange={handleChange}
                    className="form-input"
                    required
                  />
                </div>
                <div>
                  <label className="form-label">Category</label>
                  <select
                    name="category"
                    value={formData.category}
                    onChange={handleChange}
                    className="form-select"
                  >
                    {categories.map(cat => (
                      <option key={cat} value={cat}>{cat}</option>
                    ))}
                  </select>
                </div>
              </div>

              <div>
                <label className="form-label">Short Description</label>
                <input
                  type="text"
                  name="shortDescription"
                  value={formData.shortDescription}
                  onChange={handleChange}
                  className="form-input"
                  placeholder="Brief description for course cards"
                />
              </div>

              <div>
                <label className="form-label">Description *</label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  className="form-textarea"
                  rows={4}
                  required
                />
              </div>

              {/* Pricing and Duration */}
              <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                  <label className="form-label">Price ($)</label>
                  <input
                    type="number"
                    name="price"
                    value={formData.price}
                    onChange={handleChange}
                    className="form-input"
                    min="0"
                    step="0.01"
                  />
                </div>
                <div>
                  <label className="form-label">Original Price ($)</label>
                  <input
                    type="number"
                    name="originalPrice"
                    value={formData.originalPrice}
                    onChange={handleChange}
                    className="form-input"
                    min="0"
                    step="0.01"
                  />
                </div>
                <div>
                  <label className="form-label">Duration (minutes)</label>
                  <input
                    type="number"
                    name="duration"
                    value={formData.duration}
                    onChange={handleChange}
                    className="form-input"
                    min="0"
                  />
                </div>
                <div>
                  <label className="form-label">Completion Time</label>
                  <input
                    type="text"
                    name="estimatedCompletionTime"
                    value={formData.estimatedCompletionTime}
                    onChange={handleChange}
                    className="form-input"
                    placeholder="e.g., 2-3 weeks"
                  />
                </div>
              </div>

              {/* Difficulty and Type */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="form-label">Difficulty</label>
                  <select
                    name="difficulty"
                    value={formData.difficulty}
                    onChange={handleChange}
                    className="form-select"
                  >
                    {difficulties.map(diff => (
                      <option key={diff} value={diff}>{diff}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="form-label">Difficulty Level (1-5)</label>
                  <input
                    type="number"
                    name="difficultyLevel"
                    value={formData.difficultyLevel}
                    onChange={handleChange}
                    className="form-input"
                    min="1"
                    max="5"
                  />
                </div>
                <div>
                  <label className="form-label">Training Type</label>
                  <select
                    name="trainingType"
                    value={formData.trainingType}
                    onChange={handleChange}
                    className="form-select"
                  >
                    <option value="online">Online</option>
                    <option value="offline">Offline</option>
                  </select>
                </div>
              </div>

              {/* Cover Image */}
              <div>
                <label className="form-label">Cover Image URL</label>
                <input
                  type="url"
                  name="coverImage"
                  value={formData.coverImage}
                  onChange={handleChange}
                  className="form-input"
                  placeholder="https://example.com/image.jpg"
                />
              </div>

              {/* Checkboxes */}
              <div className="flex items-center space-x-6">
                <label className="flex items-center">
                  <input
                    type="checkbox"
                    name="isFeatured"
                    checked={formData.isFeatured}
                    onChange={handleChange}
                    className="mr-2"
                  />
                  Featured Course
                </label>
                <label className="flex items-center">
                  <input
                    type="checkbox"
                    name="isPopular"
                    checked={formData.isPopular}
                    onChange={handleChange}
                    className="mr-2"
                  />
                  Popular Course
                </label>
              </div>

              {/* Note about steps and badges */}
              <div className="bg-blue-50 p-4 rounded-lg">
                <p className="text-sm text-blue-700">
                  <strong>Note:</strong> Course steps and badges can be added after creating the course. 
                  This form covers the basic course information.
                </p>
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
                mode === 'edit' ? 'Update Course' : 'Create Course'
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
    </div>
  );
};

export default CourseFormModal;
