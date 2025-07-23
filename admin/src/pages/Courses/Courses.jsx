import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
  FiSearch, 
  FiFilter, 
  FiPlus, 
  FiEdit, 
  FiTrash2,
  FiRefreshCw,
  FiBookOpen
} from 'react-icons/fi';
import { fetchCourses, setFilters, openCourseForm } from '../../redux/slices/coursesSlice';
import CourseTable from '../../components/CourseTable/CourseTable';
import CourseFilters from '../../components/CourseFilters/CourseFilters';
import CourseFormModal from '../../components/CourseFormModal/CourseFormModal';

const Courses = () => {
  const dispatch = useDispatch();
  const { courses, loading, pagination, filters } = useSelector((state) => state.courses);
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    dispatch(fetchCourses(filters));
  }, [dispatch, filters]);

  const handleSearch = (searchTerm) => {
    dispatch(setFilters({ ...filters, search: searchTerm, page: 1 }));
  };

  const handleFilterChange = (newFilters) => {
    dispatch(setFilters({ ...filters, ...newFilters, page: 1 }));
  };

  const handlePageChange = (page) => {
    dispatch(setFilters({ ...filters, page }));
  };

  const handleRefresh = () => {
    dispatch(fetchCourses(filters));
  };

  const handleCreateCourse = () => {
    dispatch(openCourseForm({ mode: 'create' }));
  };

  const handleEditCourse = (course) => {
    dispatch(openCourseForm({ mode: 'edit', data: course }));
  };

  const handleDeleteCourse = (course) => {
    // TODO: Implement delete confirmation modal
    console.log('Delete course:', course);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Courses</h1>
          <p className="text-gray-600">Manage training courses and content</p>
        </div>
        <div className="flex items-center space-x-3">
          <button
            onClick={handleRefresh}
            disabled={loading}
            className="btn btn-secondary"
          >
            <FiRefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
            Refresh
          </button>
          <button
            onClick={handleCreateCourse}
            className="btn btn-primary"
          >
            <FiPlus className="w-4 h-4" />
            Create Course
          </button>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="card">
        <div className="card-body">
          <div className="flex flex-col sm:flex-row gap-4">
            {/* Search */}
            <div className="flex-1">
              <div className="relative">
                <FiSearch className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  type="text"
                  placeholder="Search courses by title or description..."
                  className="form-input pl-10"
                  value={filters.search}
                  onChange={(e) => handleSearch(e.target.value)}
                />
              </div>
            </div>

            {/* Filter Toggle */}
            <button
              onClick={() => setShowFilters(!showFilters)}
              className="btn btn-secondary"
            >
              <FiFilter className="w-4 h-4" />
              Filters
            </button>
          </div>

          {/* Filters */}
          {showFilters && (
            <div className="mt-4 pt-4 border-t border-gray-200">
              <CourseFilters
                filters={filters}
                onFilterChange={handleFilterChange}
              />
            </div>
          )}
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-blue-600">
              {pagination.totalCourses || 0}
            </div>
            <div className="text-sm text-gray-600">Total Courses</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-green-600">
              {courses.filter(c => c.isActive).length}
            </div>
            <div className="text-sm text-gray-600">Active Courses</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-purple-600">
              {courses.reduce((sum, c) => sum + (c.enrollmentCount || 0), 0)}
            </div>
            <div className="text-sm text-gray-600">Total Enrollments</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-orange-600">
              {courses.filter(c => c.isFeatured).length}
            </div>
            <div className="text-sm text-gray-600">Featured Courses</div>
          </div>
        </div>
      </div>

      {/* Courses Table */}
      <div className="card">
        <div className="card-header">
          <h3 className="text-lg font-semibold text-gray-900">
            Courses ({pagination.totalCourses || 0})
          </h3>
        </div>
        <div className="card-body p-0">
          <CourseTable
            courses={courses}
            loading={loading}
            onEdit={handleEditCourse}
            onDelete={handleDeleteCourse}
          />
        </div>
        
        {/* Pagination */}
        {pagination.totalPages > 1 && (
          <div className="card-footer">
            <div className="flex items-center justify-between">
              <div className="text-sm text-gray-600">
                Showing {((pagination.currentPage - 1) * filters.limit) + 1} to{' '}
                {Math.min(pagination.currentPage * filters.limit, pagination.totalCourses)} of{' '}
                {pagination.totalCourses} courses
              </div>
              <div className="flex items-center space-x-2">
                <button
                  onClick={() => handlePageChange(pagination.currentPage - 1)}
                  disabled={!pagination.hasPrev}
                  className="btn btn-secondary btn-sm"
                >
                  Previous
                </button>
                <span className="text-sm text-gray-600">
                  Page {pagination.currentPage} of {pagination.totalPages}
                </span>
                <button
                  onClick={() => handlePageChange(pagination.currentPage + 1)}
                  disabled={!pagination.hasNext}
                  className="btn btn-secondary btn-sm"
                >
                  Next
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Course Form Modal */}
      <CourseFormModal />
    </div>
  );
};

export default Courses;
