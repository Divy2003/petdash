import { FiEdit, FiTrash2, FiBookOpen, FiStar, FiUsers } from 'react-icons/fi';
import { format } from 'date-fns';

const CourseTable = ({ courses, loading, onEdit, onDelete }) => {
  const getDifficultyBadge = (difficulty, difficultyLevel) => {
    const colorMap = {
      'Beginner': 'bg-green-100 text-green-800',
      'Intermediate': 'bg-yellow-100 text-yellow-800',
      'Advanced': 'bg-red-100 text-red-800',
    };
    
    return (
      <div className="flex items-center space-x-2">
        <span className={`px-2 py-1 text-xs font-medium rounded-full ${colorMap[difficulty] || 'bg-gray-100 text-gray-800'}`}>
          {difficulty}
        </span>
        <div className="flex items-center">
          {[...Array(5)].map((_, i) => (
            <FiStar
              key={i}
              className={`w-3 h-3 ${
                i < difficultyLevel ? 'text-yellow-400 fill-current' : 'text-gray-300'
              }`}
            />
          ))}
        </div>
      </div>
    );
  };

  const getStatusBadge = (course) => {
    if (!course.isActive) {
      return <span className="px-2 py-1 text-xs font-medium bg-red-100 text-red-800 rounded-full">Inactive</span>;
    }
    
    const badges = [];
    
    if (course.isFeatured) {
      badges.push(
        <span key="featured" className="px-2 py-1 text-xs font-medium bg-blue-100 text-blue-800 rounded-full">
          Featured
        </span>
      );
    }
    
    if (course.isPopular) {
      badges.push(
        <span key="popular" className="px-2 py-1 text-xs font-medium bg-purple-100 text-purple-800 rounded-full">
          Popular
        </span>
      );
    }
    
    if (badges.length === 0) {
      badges.push(
        <span key="active" className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">
          Active
        </span>
      );
    }
    
    return <div className="flex flex-wrap gap-1">{badges}</div>;
  };

  if (loading) {
    return (
      <div className="p-8 text-center">
        <div className="spinner mx-auto mb-4"></div>
        <p className="text-gray-600">Loading courses...</p>
      </div>
    );
  }

  if (courses.length === 0) {
    return (
      <div className="p-8 text-center">
        <FiBookOpen className="w-12 h-12 mx-auto mb-4 text-gray-400" />
        <p className="text-gray-600">No courses found</p>
      </div>
    );
  }

  return (
    <div className="overflow-x-auto">
      <table className="table">
        <thead>
          <tr>
            <th>Course</th>
            <th>Category</th>
            <th>Difficulty</th>
            <th>Price</th>
            <th>Enrollments</th>
            <th>Status</th>
            <th>Created</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {courses.map((course) => (
            <tr key={course._id}>
              <td>
                <div className="flex items-center space-x-3">
                  <div className="w-12 h-12 bg-gray-200 rounded-lg flex items-center justify-center overflow-hidden">
                    {course.thumbnailImage || course.coverImage ? (
                      <img
                        src={course.thumbnailImage || course.coverImage}
                        alt={course.title}
                        className="w-12 h-12 object-cover"
                      />
                    ) : (
                      <FiBookOpen className="w-6 h-6 text-gray-500" />
                    )}
                  </div>
                  <div className="min-w-0 flex-1">
                    <div className="font-medium text-gray-900 truncate">{course.title}</div>
                    <div className="text-sm text-gray-500 truncate">
                      {course.shortDescription || course.description}
                    </div>
                    <div className="text-xs text-gray-400">
                      {course.duration} min • {course.steps?.length || 0} steps
                    </div>
                  </div>
                </div>
              </td>
              <td>
                <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded-full">
                  {course.category}
                </span>
              </td>
              <td>{getDifficultyBadge(course.difficulty, course.difficultyLevel)}</td>
              <td>
                <div className="text-sm">
                  <div className="font-medium text-gray-900">${course.price}</div>
                  {course.originalPrice && course.originalPrice > course.price && (
                    <div className="text-xs text-gray-500 line-through">
                      ${course.originalPrice}
                    </div>
                  )}
                </div>
              </td>
              <td>
                <div className="flex items-center space-x-1">
                  <FiUsers className="w-4 h-4 text-gray-400" />
                  <span className="text-sm text-gray-900">
                    {course.enrollmentCount || 0}
                  </span>
                </div>
                {course.averageRating && (
                  <div className="flex items-center space-x-1 mt-1">
                    <FiStar className="w-3 h-3 text-yellow-400 fill-current" />
                    <span className="text-xs text-gray-600">
                      {course.averageRating.toFixed(1)} ({course.totalReviews || 0})
                    </span>
                  </div>
                )}
              </td>
              <td>{getStatusBadge(course)}</td>
              <td>
                <div className="text-sm text-gray-900">
                  {course.createdAt ? format(new Date(course.createdAt), 'MMM dd, yyyy') : 'N/A'}
                </div>
                {course.updatedAt && course.updatedAt !== course.createdAt && (
                  <div className="text-xs text-gray-500">
                    Updated: {format(new Date(course.updatedAt), 'MMM dd')}
                  </div>
                )}
              </td>
              <td>
                <div className="flex items-center space-x-2">
                  <button
                    onClick={() => onEdit(course)}
                    className="btn btn-sm btn-secondary"
                    title="Edit Course"
                  >
                    <FiEdit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => onDelete(course)}
                    className="btn btn-sm btn-error"
                    title="Delete Course"
                  >
                    <FiTrash2 className="w-4 h-4" />
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default CourseTable;
