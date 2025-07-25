import { FiUserCheck, FiEdit, FiTrash2, FiUser } from 'react-icons/fi';
import './UserTable.css';
import { format } from 'date-fns';

const UserTable = ({ users, loading, onManageRoles, onEdit, onDelete }) => {
  const getRoleBadge = (user) => {
    const currentRole = user.currentRole || user.userType;
    const availableRoles = user.availableRoles || [];
    
    if (user.userType === 'Admin') {
      return <span className="usertable-badge usertable-badge-admin">Admin</span>;
    }
    
    if (availableRoles.length > 1) {
      return (
        <div className="flex flex-wrap gap-1">
          <span className="usertable-badge usertable-badge-business">
            {currentRole}
          </span>
          <span className="usertable-badge">
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
      <div className="usertable-empty">
        <div className="usertable-spinner"></div>
        <p className="text-gray-600">Loading users...</p>
      </div>
    );
  }

  if (users.length === 0) {
    return (
      <div className="usertable-empty">
        <FiUser className="usertable-empty-icon" />
        <p className="text-gray-600">No users found</p>
      </div>
    );
  }

  return (
    <div className="usertable-container">
      <table className="usertable-table">
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
                <div className="usertable-user">
                  <div className="usertable-avatar">
                    {user.profileImage ? (
                      <img
                        src={user.profileImage}
                        alt={user.name}
                        className="usertable-avatar-img"
                      />
                    ) : (
                      <FiUser className="w-5 h-5 text-gray-500" />
                    )}
                  </div>
                  <div>
                    <div className="usertable-name">{user.name}</div>
                    <div className="usertable-email">{user.email}</div>
                  </div>
                </div>
              </td>
              <td>{getRoleBadge(user)}</td>
              <td>{getStatusBadge(user)}</td>
              <td>
                <div className="usertable-role-switching">
                  {user.canSwitchRoles ? (
                    <span className="usertable-badge usertable-badge-active">
                      Enabled
                    </span>
                  ) : (
                    <span className="usertable-badge">
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
