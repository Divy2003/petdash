import './UserFilters.css';

const UserFilters = ({ filters, onFilterChange }) => {
  const handleFilterChange = (key, value) => {
    onFilterChange({ [key]: value });
  };

  const clearFilters = () => {
    onFilterChange({
      userType: '',
      status: '',
      canSwitchRoles: '',
    });
  };

  return (
    <div className="userfilters-section">
      <div className="userfilters-grid">
        {/* User Type Filter */}
        <div>
          <label className="userfilters-label">User Type</label>
          <select
            className="userfilters-select"
            value={filters.userType || ''}
            onChange={(e) => handleFilterChange('userType', e.target.value)}
          >
            <option value="">All Types</option>
            <option value="Pet Owner">Pet Owner</option>
            <option value="Business">Business</option>
            <option value="Admin">Admin</option>
          </select>
        </div>

        {/* Status Filter */}
        <div>
          <label className="userfilters-label">Status</label>
          <select
            className="userfilters-select"
            value={filters.status || ''}
            onChange={(e) => handleFilterChange('status', e.target.value)}
          >
            <option value="">All Status</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </div>

        {/* Role Switching Filter */}
        <div>
          <label className="userfilters-label">Role Switching</label>
          <select
            className="userfilters-select"
            value={filters.canSwitchRoles || ''}
            onChange={(e) => handleFilterChange('canSwitchRoles', e.target.value)}
          >
            <option value="">All Users</option>
            <option value="true">Can Switch Roles</option>
            <option value="false">Cannot Switch Roles</option>
          </select>
        </div>

        {/* Items per page */}
        <div>
          <label className="userfilters-label">Items per page</label>
          <select
            className="userfilters-select"
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

      {/* Clear Filters */}
      <div className="userfilters-actions">
        <button
          onClick={clearFilters}
          className="userfilters-btn-clear"
        >
          Clear Filters
        </button>
      </div>
    </div>
  );
};

export default UserFilters;
