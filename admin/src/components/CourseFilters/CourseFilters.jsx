const CourseFilters = ({ filters, onFilterChange }) => {
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

  const handleFilterChange = (key, value) => {
    onFilterChange({ [key]: value });
  };

  const clearFilters = () => {
    onFilterChange({
      category: '',
      difficulty: '',
      trainingType: 'online',
      status: '',
      isFeatured: '',
      isPopular: '',
    });
  };

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-4">
        {/* Category Filter */}
        <div>
          <label className="form-label">Category</label>
          <select
            className="form-select"
            value={filters.category || ''}
            onChange={(e) => handleFilterChange('category', e.target.value)}
          >
            <option value="">All Categories</option>
            {categories.map((category) => (
              <option key={category} value={category}>
                {category}
              </option>
            ))}
          </select>
        </div>

        {/* Difficulty Filter */}
        <div>
          <label className="form-label">Difficulty</label>
          <select
            className="form-select"
            value={filters.difficulty || ''}
            onChange={(e) => handleFilterChange('difficulty', e.target.value)}
          >
            <option value="">All Levels</option>
            {difficulties.map((difficulty) => (
              <option key={difficulty} value={difficulty}>
                {difficulty}
              </option>
            ))}
          </select>
        </div>

        {/* Training Type Filter */}
        <div>
          <label className="form-label">Training Type</label>
          <select
            className="form-select"
            value={filters.trainingType || 'online'}
            onChange={(e) => handleFilterChange('trainingType', e.target.value)}
          >
            <option value="online">Online</option>
            <option value="offline">Offline</option>
          </select>
        </div>

        {/* Status Filter */}
        <div>
          <label className="form-label">Status</label>
          <select
            className="form-select"
            value={filters.status || ''}
            onChange={(e) => handleFilterChange('status', e.target.value)}
          >
            <option value="">All Status</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </div>

        {/* Items per page */}
        <div>
          <label className="form-label">Items per page</label>
          <select
            className="form-select"
            value={filters.limit || 10}
            onChange={(e) => handleFilterChange('limit', parseInt(e.target.value))}
          >
            <option value={10}>10</option>
            <option value={25}>25</option>
            <option value={50}>50</option>
            <option value={100}>100</option>
          </select>
        </div>
      </div>

      {/* Additional Filters */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {/* Featured Filter */}
        <div>
          <label className="form-label">Featured</label>
          <select
            className="form-select"
            value={filters.isFeatured || ''}
            onChange={(e) => handleFilterChange('isFeatured', e.target.value)}
          >
            <option value="">All Courses</option>
            <option value="true">Featured Only</option>
            <option value="false">Non-Featured</option>
          </select>
        </div>

        {/* Popular Filter */}
        <div>
          <label className="form-label">Popular</label>
          <select
            className="form-select"
            value={filters.isPopular || ''}
            onChange={(e) => handleFilterChange('isPopular', e.target.value)}
          >
            <option value="">All Courses</option>
            <option value="true">Popular Only</option>
            <option value="false">Non-Popular</option>
          </select>
        </div>

        {/* Sort By */}
        <div>
          <label className="form-label">Sort By</label>
          <select
            className="form-select"
            value={filters.sortBy || 'createdAt'}
            onChange={(e) => handleFilterChange('sortBy', e.target.value)}
          >
            <option value="createdAt">Created Date</option>
            <option value="title">Title</option>
            <option value="price">Price</option>
            <option value="enrollmentCount">Enrollments</option>
            <option value="averageRating">Rating</option>
          </select>
        </div>
      </div>

      {/* Clear Filters */}
      <div className="flex justify-end">
        <button
          onClick={clearFilters}
          className="btn btn-secondary btn-sm"
        >
          Clear Filters
        </button>
      </div>
    </div>
  );
};

export default CourseFilters;
