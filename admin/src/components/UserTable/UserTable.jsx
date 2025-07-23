import { FiUserCheck, FiEdit, FiTrash2, FiUser } from 'react-icons/fi';
import { format } from 'date-fns';

const UserTable = ({ users, loading, onManageRoles, onEdit, onDelete }) => {
  const getRoleBadge = (user) => {
    const currentRole = user.currentRole || user.userType;
    const availableRoles = user.availableRoles || [];
    
    if (user.userType === 'Admin') {
      return <span className="px-2 py-1 text-xs font-medium bg-red-100 text-red-800 rounded-full">Admin</span>;
    }
    
    if (availableRoles.length > 1) {
      return (
        <div className="flex flex-wrap gap-1">
          <span className="px-2 py-1 text-xs font-medium bg-blue-100 text-blue-800 rounded-full">
            {currentRole}
          </span>
          <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-600 rounded-full">
            +{availableRoles.length - 1} more
          </span>
        </div>
      );
    }
    
    const colorMap = {
      'Pet Owner': 'bg-green-100 text-green-800',
      'Business': 'bg-purple-100 text-purple-800',
    };
    
    return (
      <span className={`px-2 py-1 text-xs font-medium rounded-full ${colorMap[currentRole] || 'bg-gray-100 text-gray-800'}`}>
        {currentRole}
      </span>
    );
  };

  const getStatusBadge = (user) => {
    const isActive = user.isActive !== false; // Default to true if not specified
    return (
      <span className={`px-2 py-1 text-xs font-medium rounded-full ${
        isActive ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
      }`}>
        {isActive ? 'Active' : 'Inactive'}
      </span>
    );
  };

  if (loading) {
    return (
      <div className="p-8 text-center">
        <div className="spinner mx-auto mb-4"></div>
        <p className="text-gray-600">Loading users...</p>
      </div>
    );
  }

  if (users.length === 0) {
    return (
      <div className="p-8 text-center">
        <FiUser className="w-12 h-12 mx-auto mb-4 text-gray-400" />
        <p className="text-gray-600">No users found</p>
      </div>
    );
  }

  return (
    <div className="overflow-x-auto">
      <table className="table">
        <thead>
          <tr>
            <th>User</th>
            <th>Role</th>
            <th>Status</th>
            <th>Role Switching</th>
            <th>Joined</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => (
            <tr key={user._id}>
              <td>
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center">
                    {user.profileImage ? (
                      <img
                        src={user.profileImage}
                        alt={user.name}
                        className="w-10 h-10 rounded-full object-cover"
                      />
                    ) : (
                      <FiUser className="w-5 h-5 text-gray-500" />
                    )}
                  </div>
                  <div>
                    <div className="font-medium text-gray-900">{user.name}</div>
                    <div className="text-sm text-gray-500">{user.email}</div>
                  </div>
                </div>
              </td>
              <td>{getRoleBadge(user)}</td>
              <td>{getStatusBadge(user)}</td>
              <td>
                <div className="flex items-center space-x-2">
                  {user.canSwitchRoles ? (
                    <span className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">
                      Enabled
                    </span>
                  ) : (
                    <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-600 rounded-full">
                      Disabled
                    </span>
                  )}
                  {user.roleHistory && user.roleHistory.length > 0 && (
                    <span className="text-xs text-gray-500">
                      ({user.roleHistory.length} switches)
                    </span>
                  )}
                </div>
              </td>
              <td>
                <div className="text-sm text-gray-900">
                  {user.createdAt ? format(new Date(user.createdAt), 'MMM dd, yyyy') : 'N/A'}
                </div>
                {user.lastLogin && (
                  <div className="text-xs text-gray-500">
                    Last: {format(new Date(user.lastLogin), 'MMM dd')}
                  </div>
                )}
              </td>
              <td>
                <div className="flex items-center space-x-2">
                  {user.userType !== 'Admin' && (
                    <button
                      onClick={() => onManageRoles(user)}
                      className="btn btn-sm btn-secondary"
                      title="Manage Roles"
                    >
                      <FiUserCheck className="w-4 h-4" />
                    </button>
                  )}
                  <button
                    onClick={() => onEdit(user)}
                    className="btn btn-sm btn-secondary"
                    title="Edit User"
                  >
                    <FiEdit className="w-4 h-4" />
                  </button>
                  {user.userType !== 'Admin' && (
                    <button
                      onClick={() => onDelete(user)}
                      className="btn btn-sm btn-error"
                      title="Delete User"
                    >
                      <FiTrash2 className="w-4 h-4" />
                    </button>
                  )}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default UserTable;
