import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
  FiSearch, 
  FiFilter, 
  FiUserCheck, 
  FiEdit, 
  FiTrash2,
  FiRefreshCw,
  FiPlus
} from 'react-icons/fi';
import { fetchUsers, setFilters } from '../../redux/slices/usersSlice';
import { openRoleManagement } from '../../redux/slices/uiSlice';
import UserTable from '../../components/UserTable/UserTable';
import UserFilters from '../../components/UserFilters/UserFilters';
import RoleManagementModal from '../../components/RoleManagementModal/RoleManagementModal';

const Users = () => {
  const dispatch = useDispatch();
  const { users, loading, pagination, filters } = useSelector((state) => state.users);
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    dispatch(fetchUsers(filters));
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
    dispatch(fetchUsers(filters));
  };

  const handleManageRoles = (user) => {
    dispatch(openRoleManagement(user));
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Users</h1>
          <p className="text-gray-600">Manage users and their roles</p>
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
          <button className="btn btn-primary">
            <FiPlus className="w-4 h-4" />
            Add User
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
                  placeholder="Search users by name or email..."
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
              <UserFilters
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
              {pagination.totalUsers || 0}
            </div>
            <div className="text-sm text-gray-600">Total Users</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-green-600">
              {users.filter(u => u.userType === 'Pet Owner').length}
            </div>
            <div className="text-sm text-gray-600">Pet Owners</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-purple-600">
              {users.filter(u => u.userType === 'Business').length}
            </div>
            <div className="text-sm text-gray-600">Businesses</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-orange-600">
              {users.filter(u => u.canSwitchRoles).length}
            </div>
            <div className="text-sm text-gray-600">Role Switchers</div>
          </div>
        </div>
      </div>

      {/* Users Table */}
      <div className="card">
        <div className="card-header">
          <h3 className="text-lg font-semibold text-gray-900">
            Users ({pagination.totalUsers || 0})
          </h3>
        </div>
        <div className="card-body p-0">
          <UserTable
            users={users}
            loading={loading}
            onManageRoles={handleManageRoles}
            onEdit={(user) => console.log('Edit user:', user)}
            onDelete={(user) => console.log('Delete user:', user)}
          />
        </div>
        
        {/* Pagination */}
        {pagination.totalPages > 1 && (
          <div className="card-footer">
            <div className="flex items-center justify-between">
              <div className="text-sm text-gray-600">
                Showing {((pagination.currentPage - 1) * filters.limit) + 1} to{' '}
                {Math.min(pagination.currentPage * filters.limit, pagination.totalUsers)} of{' '}
                {pagination.totalUsers} users
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

      {/* Role Management Modal */}
      <RoleManagementModal />
    </div>
  );
};

export default Users;
