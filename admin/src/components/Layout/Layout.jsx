import { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import {
  FiMenu,
  FiX,
  FiHome,
  FiUsers,
  FiBookOpen,
  FiBarChart2,
  FiGrid,
  FiLogOut,
  FiBell,
  FiUser,
  FiUserCheck,
  FiChevronDown,
  FiChevronRight
} from 'react-icons/fi';
import { logout } from '../../redux/slices/authSlice';
import DeleteConfirmModal from '../DeleteConfirmModal/DeleteConfirmModal';

const Layout = ({ children }) => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useSelector((state) => state.auth);
  const [profileDropdownOpen, setProfileDropdownOpen] = useState(false);

  const menuItems = [
    {
      path: '/dashboard',
      icon: FiHome,
      label: 'Dashboard',
      description: 'Overview & Statistics'
    },
    {
      path: '/users',
      icon: FiUsers,
      label: 'Users',
      description: 'Manage Users'
    },
    {
      path: '/courses',
      icon: FiBookOpen,
      label: 'Courses',
      description: 'Training Content'
    },
    {
      path: '/categories',
      icon: FiGrid,
      label: 'Categories',
      description: 'Service Categories'
    },
    {
      path: '/analytics',
      icon: FiBarChart2,
      label: 'Analytics',
      description: 'Reports & Insights'
    },
    {
      path: '/role-management',
      icon: FiUserCheck,
      label: 'Role Management',
      description: 'User Permissions'
    },
  ];

  const handleLogout = () => {
    dispatch(logout());
    navigate('/login');
  };

  const isActiveRoute = (path) => {
    return location.pathname === path;
  };

  return (
    <div className="min-h-screen flex bg-gray-50">
      {/* Sidebar */}
      <div className="w-64 h-screen flex flex-col bg-white shadow-lg">
        {/* Sidebar Header */}
        <div className="flex items-center h-16 px-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 to-blue-700">
          <div className="w-10 h-10 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <span className="text-white font-bold text-lg">🐾</span>
          </div>
          <div className="ml-3">
            <span className="text-white font-bold text-xl">PetPatch</span>
            <div className="text-blue-100 text-xs">Admin Panel</div>
          </div>
        </div>
        {/* Navigation */}
        <nav className="mt-6 px-4 flex-1 overflow-y-auto">
          <div className="space-y-2">
            {menuItems.map((item) => {
              const Icon = item.icon;
              const active = isActiveRoute(item.path);
              return (
                <button
                  key={item.path}
                  onClick={() => navigate(item.path)}
                  className={`w-full group flex items-center px-4 py-3 text-sm font-medium rounded-xl transition-all duration-200 ${
                    active
                      ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-lg shadow-blue-500/25'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900 hover:shadow-sm'
                  }`}
                >
                  <Icon className="w-5 h-5 mr-3" />
                  <span>{item.label}</span>
                </button>
              );
            })}
          </div>
        </nav>
        {/* User Info */}
        <div className="p-4 border-t border-gray-200 bg-gray-50">
          <div className="flex items-center p-3 bg-white rounded-xl shadow-sm">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center">
              <FiUser className="w-5 h-5 text-white" />
            </div>
            <div className="ml-3 flex-1 min-w-0">
              <p className="text-sm font-semibold text-gray-900 truncate">
                {user?.name || 'Admin User'}
              </p>
              <p className="text-xs text-gray-500 truncate">
                {user?.email || 'admin@petpatch.com'}
              </p>
              <div className="flex items-center mt-1">
                <div className="w-2 h-2 bg-green-400 rounded-full mr-2"></div>
                <span className="text-xs text-green-600 font-medium">Online</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col min-h-screen">
        {/* Top Header */}
        <header className="bg-white shadow-sm border-b border-gray-200">
          <div className="flex items-center justify-between h-16 px-6">
            <h1 className="ml-2 text-2xl font-semibold text-gray-900 capitalize">
              {location.pathname.slice(1) || 'Dashboard'}
            </h1>
          </div>
        </header>
        {/* Page Content */}
        <main className="flex-1 p-6">
          {children}
        </main>
        {/* Delete Confirmation Modal */}
        <DeleteConfirmModal />
      </div>
    </div>
  );
};

export default Layout;
