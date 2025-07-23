import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { 
  FiUsers, 
  FiUserCheck, 
  FiRefreshCw,
  FiSearch,
  FiSettings
} from 'react-icons/fi';
import { toast } from 'react-hot-toast';
import { fetchUsers } from '../../redux/slices/usersSlice';
import { getRoleAnalytics, bulkEnableRoles } from '../../redux/slices/authSlice';
import RoleManagementModal from '../../components/RoleManagementModal/RoleManagementModal';
import { openRoleManagement } from '../../redux/slices/uiSlice';

const RoleManagement = () => {
  const dispatch = useDispatch();
  const { users, loading: usersLoading } = useSelector((state) => state.users);
  const { roleAnalytics, loading: analyticsLoading, roleOperationLoading } = useSelector((state) => state.auth);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [bulkAction, setBulkAction] = useState('');

  useEffect(() => {
    dispatch(fetchUsers({ limit: 100 })); // Get more users for role management
    dispatch(getRoleAnalytics());
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(fetchUsers({ limit: 100 }));
    dispatch(getRoleAnalytics());
  };

  const handleUserSelect = (userId) => {
    setSelectedUsers(prev => 
      prev.includes(userId) 
        ? prev.filter(id => id !== userId)
        : [...prev, userId]
    );
  };

  const handleSelectAll = () => {
    const eligibleUsers = filteredUsers.filter(user => user.userType !== 'Admin');
    if (selectedUsers.length === eligibleUsers.length) {
      setSelectedUsers([]);
    } else {
      setSelectedUsers(eligibleUsers.map(user => user._id));
    }
  };

  const handleBulkAction = async () => {
    if (!bulkAction || selectedUsers.length === 0) {
      toast.error('Please select users and an action');
      return;
    }

    try {
      let rolesToEnable = [];
      if (bulkAction === 'enable-both') {
        rolesToEnable = ['Pet Owner', 'Business'];
      } else if (bulkAction === 'enable-petowner') {
        rolesToEnable = ['Pet Owner'];
      } else if (bulkAction === 'enable-business') {
        rolesToEnable = ['Business'];
      }

      await dispatch(bulkEnableRoles({
        userIds: selectedUsers,
        rolesToEnable
      })).unwrap();

      toast.success(`Role switching updated for ${selectedUsers.length} users`);
      setSelectedUsers([]);
      setBulkAction('');
      dispatch(fetchUsers({ limit: 100 }));
    } catch (error) {
      toast.error(error || 'Failed to update role switching');
    }
  };

  const filteredUsers = users.filter(user => 
    user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.email.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const nonAdminUsers = filteredUsers.filter(user => user.userType !== 'Admin');
  const usersWithRoleSwitching = nonAdminUsers.filter(user => user.canSwitchRoles);
  const usersWithoutRoleSwitching = nonAdminUsers.filter(user => !user.canSwitchRoles);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Role Management</h1>
          <p className="text-gray-600">Enable and manage user role switching</p>
        </div>
        <button
          onClick={handleRefresh}
          disabled={usersLoading || analyticsLoading}
          className="btn btn-secondary"
        >
          <FiRefreshCw className={`w-4 h-4 ${(usersLoading || analyticsLoading) ? 'animate-spin' : ''}`} />
          Refresh
        </button>
      </div>

      {/* Analytics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-blue-600">
              {roleAnalytics?.totalUsers || 0}
            </div>
            <div className="text-sm text-gray-600">Total Users</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-green-600">
              {usersWithRoleSwitching.length}
            </div>
            <div className="text-sm text-gray-600">Role Switching Enabled</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-orange-600">
              {roleAnalytics?.activeRoleSwitchers || 0}
            </div>
            <div className="text-sm text-gray-600">Active Switchers</div>
          </div>
        </div>
        <div className="card">
          <div className="card-body text-center">
            <div className="text-2xl font-bold text-purple-600">
              {roleAnalytics?.roleSwitchStats?.totalSwitches || 0}
            </div>
            <div className="text-sm text-gray-600">Total Switches</div>
          </div>
        </div>
      </div>

      {/* Search and Bulk Actions */}
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
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
            </div>

            {/* Bulk Actions */}
            {selectedUsers.length > 0 && (
              <div className="flex items-center space-x-2">
                <select
                  value={bulkAction}
                  onChange={(e) => setBulkAction(e.target.value)}
                  className="form-select"
                >
                  <option value="">Select Action</option>
                  <option value="enable-both">Enable Both Roles</option>
                  <option value="enable-petowner">Enable Pet Owner Only</option>
                  <option value="enable-business">Enable Business Only</option>
                </select>
                <button
                  onClick={handleBulkAction}
                  disabled={!bulkAction || roleOperationLoading}
                  className="btn btn-primary"
                >
                  {roleOperationLoading ? (
                    <div className="flex items-center">
                      <div className="spinner mr-2"></div>
                      Updating...
                    </div>
                  ) : (
                    `Apply to ${selectedUsers.length} users`
                  )}
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Users Table */}
      <div className="card">
        <div className="card-header">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold text-gray-900">
              Users ({filteredUsers.length})
            </h3>
            <button
              onClick={handleSelectAll}
              className="btn btn-secondary btn-sm"
            >
              {selectedUsers.length === nonAdminUsers.length ? 'Deselect All' : 'Select All'}
            </button>
          </div>
        </div>
        <div className="card-body p-0">
          {usersLoading ? (
            <div className="p-8 text-center">
              <div className="spinner mx-auto mb-4"></div>
              <p className="text-gray-600">Loading users...</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="table">
                <thead>
                  <tr>
                    <th>
                      <input
                        type="checkbox"
                        checked={selectedUsers.length === nonAdminUsers.length && nonAdminUsers.length > 0}
                        onChange={handleSelectAll}
                        className="rounded"
                      />
                    </th>
                    <th>User</th>
                    <th>Type</th>
                    <th>Current Role</th>
                    <th>Available Roles</th>
                    <th>Role Switching</th>
                    <th>Switches</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map((user) => (
                    <tr key={user._id}>
                      <td>
                        {user.userType !== 'Admin' && (
                          <input
                            type="checkbox"
                            checked={selectedUsers.includes(user._id)}
                            onChange={() => handleUserSelect(user._id)}
                            className="rounded"
                          />
                        )}
                      </td>
                      <td>
                        <div className="flex items-center space-x-3">
                          <div className="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center">
                            <FiUsers className="w-4 h-4 text-gray-500" />
                          </div>
                          <div>
                            <div className="font-medium text-gray-900">{user.name}</div>
                            <div className="text-sm text-gray-500">{user.email}</div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span className={`px-2 py-1 text-xs font-medium rounded-full ${
                          user.userType === 'Admin' ? 'bg-red-100 text-red-800' :
                          user.userType === 'Pet Owner' ? 'bg-green-100 text-green-800' :
                          'bg-purple-100 text-purple-800'
                        }`}>
                          {user.userType}
                        </span>
                      </td>
                      <td>
                        <span className="text-sm text-gray-900">
                          {user.currentRole || user.userType}
                        </span>
                      </td>
                      <td>
                        <div className="flex flex-wrap gap-1">
                          {(user.availableRoles || [user.userType]).map((role, index) => (
                            <span
                              key={index}
                              className="px-2 py-1 text-xs bg-gray-100 text-gray-700 rounded"
                            >
                              {role}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td>
                        {user.userType === 'Admin' ? (
                          <span className="text-xs text-gray-500">N/A</span>
                        ) : user.canSwitchRoles ? (
                          <span className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">
                            Enabled
                          </span>
                        ) : (
                          <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-600 rounded-full">
                            Disabled
                          </span>
                        )}
                      </td>
                      <td>
                        <span className="text-sm text-gray-600">
                          {user.roleHistory?.length || 0}
                        </span>
                      </td>
                      <td>
                        {user.userType !== 'Admin' && (
                          <button
                            onClick={() => dispatch(openRoleManagement(user))}
                            className="btn btn-sm btn-secondary"
                            title="Manage Roles"
                          >
                            <FiSettings className="w-4 h-4" />
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="card">
          <div className="card-header">
            <h3 className="text-lg font-semibold text-gray-900">Users Without Role Switching</h3>
          </div>
          <div className="card-body">
            <div className="text-center mb-4">
              <div className="text-3xl font-bold text-orange-600">
                {usersWithoutRoleSwitching.length}
              </div>
              <div className="text-sm text-gray-600">Users need role switching enabled</div>
            </div>
            {usersWithoutRoleSwitching.length > 0 && (
              <button
                onClick={() => {
                  setSelectedUsers(usersWithoutRoleSwitching.map(u => u._id));
                  setBulkAction('enable-both');
                }}
                className="btn btn-primary w-full"
              >
                Enable for All ({usersWithoutRoleSwitching.length})
              </button>
            )}
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <h3 className="text-lg font-semibold text-gray-900">Role Distribution</h3>
          </div>
          <div className="card-body">
            {roleAnalytics?.usersByType ? (
              <div className="space-y-3">
                {Object.entries(roleAnalytics.usersByType).map(([type, count]) => (
                  <div key={type} className="flex justify-between items-center">
                    <span className="text-gray-600">{type}</span>
                    <div className="flex items-center space-x-2">
                      <span className="font-medium">{count}</span>
                      <div className="w-16 bg-gray-200 rounded-full h-2">
                        <div
                          className="bg-blue-600 h-2 rounded-full"
                          style={{
                            width: `${(count / roleAnalytics.totalUsers) * 100}%`
                          }}
                        />
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center text-gray-500">
                No role distribution data available
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Role Management Modal */}
      <RoleManagementModal />
    </div>
  );
};

export default RoleManagement;
