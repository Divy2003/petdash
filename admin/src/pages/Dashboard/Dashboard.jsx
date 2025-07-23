import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
  FiUsers, 
  FiBookOpen, 
  FiDollarSign, 
  FiTrendingUp,
  FiUserCheck,
  FiRefreshCw
} from 'react-icons/fi';
import { fetchSystemStats } from '../../redux/slices/analyticsSlice';
import StatsCard from '../../components/StatsCard/StatsCard';
import RecentActivity from '../../components/RecentActivity/RecentActivity';

const Dashboard = () => {
  const dispatch = useDispatch();
  const { systemStats, loading } = useSelector((state) => state.analytics);

  useEffect(() => {
    dispatch(fetchSystemStats());
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(fetchSystemStats());
  };

  const statsCards = [
    {
      title: 'Total Users',
      value: systemStats?.users?.total || 0,
      change: `+${systemStats?.users?.newThisMonth || 0} this month`,
      icon: FiUsers,
      color: 'blue',
    },
    {
      title: 'Active Courses',
      value: systemStats?.courses?.active || 0,
      change: `${systemStats?.courses?.enrollments || 0} enrollments`,
      icon: FiBookOpen,
      color: 'green',
    },
    {
      title: 'Total Revenue',
      value: `$${(systemStats?.revenue?.total || 0).toLocaleString()}`,
      change: `+$${(systemStats?.revenue?.thisMonth || 0).toLocaleString()} this month`,
      icon: FiDollarSign,
      color: 'purple',
    },
    {
      title: 'Role Switchers',
      value: systemStats?.roleSwitching?.activeSwitchers || 0,
      change: `${systemStats?.roleSwitching?.enabledUsers || 0} enabled`,
      icon: FiUserCheck,
      color: 'orange',
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-600">Welcome back! Here's what's happening with your platform.</p>
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

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {statsCards.map((stat, index) => (
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

      {/* Charts and Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Revenue Chart */}
        <div className="lg:col-span-2">
          <div className="card">
            <div className="card-header">
              <h3 className="text-lg font-semibold text-gray-900">Revenue Overview</h3>
            </div>
            <div className="card-body">
              {loading ? (
                <div className="flex items-center justify-center h-64">
                  <div className="spinner"></div>
                </div>
              ) : (
                <div className="h-64 flex items-center justify-center text-gray-500">
                  <div className="text-center">
                    <FiTrendingUp className="w-12 h-12 mx-auto mb-4 text-gray-400" />
                    <p>Revenue chart will be displayed here</p>
                    <p className="text-sm">Total: ${(systemStats?.revenue?.total || 0).toLocaleString()}</p>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Recent Activity */}
        <div>
          <RecentActivity />
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="card">
          <div className="card-body text-center">
            <FiUsers className="w-8 h-8 mx-auto mb-4 text-blue-600" />
            <h3 className="text-lg font-semibold mb-2">User Management</h3>
            <p className="text-gray-600 mb-4">Manage users and their roles</p>
            <button 
              onClick={() => window.location.href = '/users'}
              className="btn btn-primary"
            >
              View Users
            </button>
          </div>
        </div>

        <div className="card">
          <div className="card-body text-center">
            <FiBookOpen className="w-8 h-8 mx-auto mb-4 text-green-600" />
            <h3 className="text-lg font-semibold mb-2">Course Management</h3>
            <p className="text-gray-600 mb-4">Create and manage training courses</p>
            <button 
              onClick={() => window.location.href = '/courses'}
              className="btn btn-primary"
            >
              View Courses
            </button>
          </div>
        </div>

        <div className="card">
          <div className="card-body text-center">
            <FiUserCheck className="w-8 h-8 mx-auto mb-4 text-orange-600" />
            <h3 className="text-lg font-semibold mb-2">Role Management</h3>
            <p className="text-gray-600 mb-4">Enable role switching for users</p>
            <button 
              onClick={() => window.location.href = '/role-management'}
              className="btn btn-primary"
            >
              Manage Roles
            </button>
          </div>
        </div>
      </div>

      {/* System Health */}
      <div className="card">
        <div className="card-header">
          <h3 className="text-lg font-semibold text-gray-900">System Health</h3>
        </div>
        <div className="card-body">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">
                {systemStats?.users?.active || 0}
              </div>
              <div className="text-sm text-gray-600">Active Users</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                {systemStats?.appointments?.thisMonth || 0}
              </div>
              <div className="text-sm text-gray-600">Appointments This Month</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-purple-600">
                {systemStats?.courses?.enrollments || 0}
              </div>
              <div className="text-sm text-gray-600">Course Enrollments</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-orange-600">
                {systemStats?.roleSwitching?.totalSwitches || 0}
              </div>
              <div className="text-sm text-gray-600">Role Switches</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
