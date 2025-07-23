import { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FiX, FiUser, FiUserCheck } from 'react-icons/fi';
import { toast } from 'react-hot-toast';
import { closeRoleManagement } from '../../redux/slices/uiSlice';
import { enableRoleSwitching } from '../../redux/slices/authSlice';
import { updateUserInList } from '../../redux/slices/usersSlice';

const RoleManagementModal = () => {
  const dispatch = useDispatch();
  const { modals } = useSelector((state) => state.ui);
  const { roleOperationLoading } = useSelector((state) => state.auth);
  const { isOpen, user } = modals.roleManagement;

  const [selectedRoles, setSelectedRoles] = useState([]);

  useEffect(() => {
    if (user) {
      setSelectedRoles(user.availableRoles || [user.userType]);
    }
  }, [user]);

  const availableRoles = ['Pet Owner', 'Business'];

  const handleRoleToggle = (role) => {
    if (role === user?.userType) {
      // Cannot remove the user's primary type
      return;
    }

    setSelectedRoles(prev => {
      if (prev.includes(role)) {
        return prev.filter(r => r !== role);
      } else {
        return [...prev, role];
      }
    });
  };

  const handleSave = async () => {
    if (!user || selectedRoles.length === 0) {
      toast.error('Please select at least one role');
      return;
    }

    try {
      await dispatch(enableRoleSwitching({
        userId: user._id,
        rolesToEnable: selectedRoles
      })).unwrap();

      // Update user in the list
      dispatch(updateUserInList({
        ...user,
        availableRoles: selectedRoles,
        canSwitchRoles: selectedRoles.length > 1
      }));

      toast.success('Role switching updated successfully');
      dispatch(closeRoleManagement());
    } catch (error) {
      toast.error(error || 'Failed to update role switching');
    }
  };

  const handleClose = () => {
    dispatch(closeRoleManagement());
  };

  if (!isOpen || !user) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        {/* Background overlay */}
        <div
          className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
          onClick={handleClose}
        />

        {/* Modal */}
        <div className="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          {/* Header */}
          <div className="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-medium text-gray-900">
                Manage Role Switching
              </h3>
              <button
                onClick={handleClose}
                className="text-gray-400 hover:text-gray-600"
              >
                <FiX className="w-6 h-6" />
              </button>
            </div>

            {/* User Info */}
            <div className="flex items-center space-x-3 mb-6 p-3 bg-gray-50 rounded-lg">
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
                <div className="text-xs text-gray-500">
                  Primary Type: {user.userType}
                </div>
              </div>
            </div>

            {/* Role Selection */}
            <div className="space-y-4">
              <div>
                <label className="text-sm font-medium text-gray-700 mb-3 block">
                  Available Roles
                </label>
                <div className="space-y-2">
                  {availableRoles.map((role) => {
                    const isSelected = selectedRoles.includes(role);
                    const isPrimaryType = role === user.userType;
                    
                    return (
                      <div
                        key={role}
                        className={`flex items-center justify-between p-3 border rounded-lg cursor-pointer transition-colors ${
                          isSelected
                            ? 'border-blue-500 bg-blue-50'
                            : 'border-gray-200 hover:border-gray-300'
                        } ${isPrimaryType ? 'opacity-75' : ''}`}
                        onClick={() => !isPrimaryType && handleRoleToggle(role)}
                      >
                        <div className="flex items-center space-x-3">
                          <div className={`w-4 h-4 rounded border-2 flex items-center justify-center ${
                            isSelected
                              ? 'border-blue-500 bg-blue-500'
                              : 'border-gray-300'
                          }`}>
                            {isSelected && (
                              <FiUserCheck className="w-3 h-3 text-white" />
                            )}
                          </div>
                          <div>
                            <div className="font-medium text-gray-900">{role}</div>
                            {isPrimaryType && (
                              <div className="text-xs text-gray-500">Primary type (required)</div>
                            )}
                          </div>
                        </div>
                        {isPrimaryType && (
                          <span className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded">
                            Required
                          </span>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Current Status */}
              <div className="p-3 bg-gray-50 rounded-lg">
                <div className="text-sm font-medium text-gray-700 mb-2">
                  Current Status
                </div>
                <div className="text-sm text-gray-600">
                  <div>Current Role: {user.currentRole || user.userType}</div>
                  <div>Available Roles: {(user.availableRoles || [user.userType]).join(', ')}</div>
                  <div>Can Switch Roles: {user.canSwitchRoles ? 'Yes' : 'No'}</div>
                  {user.roleHistory && user.roleHistory.length > 0 && (
                    <div>Total Switches: {user.roleHistory.length}</div>
                  )}
                </div>
              </div>

              {/* Preview */}
              <div className="p-3 bg-blue-50 rounded-lg">
                <div className="text-sm font-medium text-blue-700 mb-2">
                  After Update
                </div>
                <div className="text-sm text-blue-600">
                  <div>Available Roles: {selectedRoles.join(', ')}</div>
                  <div>Can Switch Roles: {selectedRoles.length > 1 ? 'Yes' : 'No'}</div>
                </div>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button
              onClick={handleSave}
              disabled={roleOperationLoading || selectedRoles.length === 0}
              className="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {roleOperationLoading ? (
                <div className="flex items-center">
                  <div className="spinner mr-2"></div>
                  Updating...
                </div>
              ) : (
                'Update Roles'
              )}
            </button>
            <button
              onClick={handleClose}
              disabled={roleOperationLoading}
              className="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RoleManagementModal;
