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
    <div className="space-y-4">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        {/* User Type Filter */}
        <div>
          <label className="form-label">User Type</label>
          <select
            className="form-select"
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

        {/* Role Switching Filter */}
        <div>
          <label className="form-label">Role Switching</label>
          <select
            className="form-select"
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

export default UserFilters;
