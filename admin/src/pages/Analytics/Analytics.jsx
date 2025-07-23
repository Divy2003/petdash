import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
  FiRefreshCw, 
  FiTrendingUp, 
  FiUsers, 
  FiBookOpen, 
  FiDollarSign,
  FiUserCheck
} from 'react-icons/fi';
import { 
  fetchSystemStats, 
  fetchCourseAnalytics, 
  fetchRoleAnalytics 
} from '../../redux/slices/analyticsSlice';
import StatsCard from '../../components/StatsCard/StatsCard';

const Analytics = () => {
  const dispatch = useDispatch();
  const { systemStats, courseAnalytics, roleAnalytics, loading } = useSelector(
    (state) => state.analytics
  );

  useEffect(() => {
    dispatch(fetchSystemStats());
    dispatch(fetchCourseAnalytics());
    dispatch(fetchRoleAnalytics());
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(fetchSystemStats());
    dispatch(fetchCourseAnalytics());
    dispatch(fetchRoleAnalytics());
  };

  const systemStatsCards = [
    {
      title: 'Total Users',
      value: systemStats?.users?.total || 0,
      change: `+${systemStats?.users?.newThisMonth || 0} this month`,
      icon: FiUsers,
      color: 'blue',
    },
    {
      title: 'Total Revenue',
      value: `$${(systemStats?.revenue?.total || 0).toLocaleString()}`,
      change: `+$${(systemStats?.revenue?.thisMonth || 0).toLocaleString()} this month`,
      icon: FiDollarSign,
      color: 'green',
    },
    {
      title: 'Active Courses',
      value: systemStats?.courses?.active || 0,
      change: `${systemStats?.courses?.enrollments || 0} total enrollments`,
      icon: FiBookOpen,
      color: 'purple',
    },
    {
      title: 'Role Switchers',
      value: systemStats?.roleSwitching?.activeSwitchers || 0,
      change: `${systemStats?.roleSwitching?.totalSwitches || 0} total switches`,
      icon: FiUserCheck,
      color: 'orange',
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Analytics</h1>
          <p className="text-gray-600">Platform performance and insights</p>
        </div>
        <button
          onClick={handleRefresh}
          disabled={loading}
          className="btn btn-secondary"
        >
          <FiRefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
          Refresh
        </button>
      </div>

      {/* System Overview */}
      <div>
        <h2 className="text-lg font-semibold text-gray-900 mb-4">System Overview</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {systemStatsCards.map((stat, index) => (
            <StatsCard
              key={index}
              title={stat.title}
              value={stat.value}
              change={stat.change}
              icon={stat.icon}
              color={stat.color}
              loading={loading}
            />
          ))}
        </div>
      </div>

      {/* Course Analytics */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="card">
          <div className="card-header">
            <h3 className="text-lg font-semibold text-gray-900">Course Performance</h3>
          </div>
          <div className="card-body">
            {loading ? (
              <div className="flex items-center justify-center h-48">
                <div className="spinner"></div>
              </div>
            ) : courseAnalytics ? (
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-blue-600">
                      {courseAnalytics.totalCourses || 0}
                    </div>
                    <div className="text-sm text-gray-600">Total Courses</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-green-600">
                      {courseAnalytics.totalEnrollments || 0}
                    </div>
                    <div className="text-sm text-gray-600">Total Enrollments</div>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-purple-600">
                      {courseAnalytics.totalCompletions || 0}
                    </div>
                    <div className="text-sm text-gray-600">Completions</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-orange-600">
                      {courseAnalytics.averageCompletionRate?.toFixed(1) || 0}%
                    </div>
                    <div className="text-sm text-gray-600">Completion Rate</div>
                  </div>
                </div>
                <div className="text-center pt-4 border-t">
                  <div className="text-2xl font-bold text-green-600">
                    ${(courseAnalytics.totalRevenue || 0).toLocaleString()}
                  </div>
                  <div className="text-sm text-gray-600">Course Revenue</div>
                </div>
              </div>
            ) : (
              <div className="text-center text-gray-500 py-8">
                No course analytics available
              </div>
            )}
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <h3 className="text-lg font-semibold text-gray-900">Role Switching Analytics</h3>
          </div>
          <div className="card-body">
            {loading ? (
              <div className="flex items-center justify-center h-48">
                <div className="spinner"></div>
              </div>
            ) : roleAnalytics ? (
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-blue-600">
                      {roleAnalytics.totalUsers || 0}
                    </div>
                    <div className="text-sm text-gray-600">Total Users</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-green-600">
                      {roleAnalytics.roleSwitchingEnabled || 0}
                    </div>
                    <div className="text-sm text-gray-600">Role Switching Enabled</div>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-purple-600">
                      {roleAnalytics.activeRoleSwitchers || 0}
                    </div>
                    <div className="text-sm text-gray-600">Active Switchers</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-orange-600">
                      {roleAnalytics.roleSwitchStats?.totalSwitches || 0}
                    </div>
                    <div className="text-sm text-gray-600">Total Switches</div>
                  </div>
                </div>
                
                {/* User Type Breakdown */}
                {roleAnalytics.usersByType && (
                  <div className="pt-4 border-t">
                    <div className="text-sm font-medium text-gray-700 mb-2">User Types</div>
                    <div className="space-y-2">
                      {Object.entries(roleAnalytics.usersByType).map(([type, count]) => (
                        <div key={type} className="flex justify-between text-sm">
                          <span className="text-gray-600">{type}</span>
                          <span className="font-medium">{count}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <div className="text-center text-gray-500 py-8">
                No role analytics available
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Top Courses */}
      {courseAnalytics?.topCourses && courseAnalytics.topCourses.length > 0 && (
        <div className="card">
          <div className="card-header">
            <h3 className="text-lg font-semibold text-gray-900">Top Performing Courses</h3>
          </div>
          <div className="card-body">
            <div className="overflow-x-auto">
              <table className="table">
                <thead>
                  <tr>
                    <th>Course</th>
                    <th>Enrollments</th>
                    <th>Completions</th>
                    <th>Rating</th>
                    <th>Revenue</th>
                  </tr>
                </thead>
                <tbody>
                  {courseAnalytics.topCourses.map((course, index) => (
                    <tr key={course._id || index}>
                      <td className="font-medium">{course.title}</td>
                      <td>{course.enrollments || 0}</td>
                      <td>{course.completions || 0}</td>
                      <td>
                        <div className="flex items-center">
                          <span className="text-yellow-400 mr-1">★</span>
                          {course.rating?.toFixed(1) || 'N/A'}
                        </div>
                      </td>
                      <td>${((course.enrollments || 0) * (course.price || 0)).toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Category Performance */}
      {courseAnalytics?.categoryStats && courseAnalytics.categoryStats.length > 0 && (
        <div className="card">
          <div className="card-header">
            <h3 className="text-lg font-semibold text-gray-900">Category Performance</h3>
          </div>
          <div className="card-body">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {courseAnalytics.categoryStats.map((category, index) => (
                <div key={index} className="p-4 border border-gray-200 rounded-lg">
                  <div className="font-medium text-gray-900 mb-2">{category.category}</div>
                  <div className="space-y-1 text-sm text-gray-600">
                    <div className="flex justify-between">
                      <span>Courses:</span>
                      <span>{category.courseCount}</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Enrollments:</span>
                      <span>{category.enrollments}</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Revenue:</span>
                      <span>${(category.revenue || 0).toLocaleString()}</span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Analytics;
