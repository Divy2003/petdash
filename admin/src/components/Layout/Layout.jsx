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
import { toggleSidebar } from '../../redux/slices/uiSlice';
import DeleteConfirmModal from '../DeleteConfirmModal/DeleteConfirmModal';

const Layout = ({ children }) => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useSelector((state) => state.auth);
  const { sidebarOpen } = useSelector((state) => state.ui);
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
    <div className="min-h-screen bg-gray-50">
      {/* Sidebar */}
      <div className={`fixed inset-y-0 left-0 z-50 w-64 bg-white shadow-lg transform ${
        sidebarOpen ? 'translate-x-0' : '-translate-x-full'
      } transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0`}>
        
        {/* Sidebar Header */}
        <div className="flex items-center justify-between h-16 px-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 to-blue-700">
          <div className="flex items-center">
            <div className="w-10 h-10 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <span className="text-white font-bold text-lg">🐾</span>
            </div>
            <div className="ml-3">
              <span className="text-white font-bold text-xl">PetPatch</span>
              <div className="text-blue-100 text-xs">Admin Panel</div>
            </div>
          </div>
          <button
            onClick={() => dispatch(toggleSidebar())}
            className="lg:hidden p-2 rounded-lg text-white hover:bg-white hover:bg-opacity-20 transition-colors"
          >
            <FiX className="w-5 h-5" />
          </button>
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
                  <div className={`p-2 rounded-lg mr-3 transition-colors ${
                    active
                      ? 'bg-white bg-opacity-20'
                      : 'bg-gray-100 group-hover:bg-gray-200'
                  }`}>
                    <Icon className={`w-4 h-4 ${active ? 'text-white' : 'text-gray-500'}`} />
                  </div>
                  <div className="flex-1 text-left">
                    <div className={`font-semibold ${active ? 'text-white' : 'text-gray-700'}`}>
                      {item.label}
                    </div>
                    <div className={`text-xs ${active ? 'text-blue-100' : 'text-gray-500'}`}>
                      {item.description}
                    </div>
                  </div>
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
      <div className={`lg:ml-64 flex flex-col min-h-screen`}>
        {/* Top Header */}
        <header className="bg-white shadow-sm border-b border-gray-200">
          <div className="flex items-center justify-between h-16 px-6">
            <div className="flex items-center">
              <button
                onClick={() => dispatch(toggleSidebar())}
                className="lg:hidden p-2 rounded-md text-gray-400 hover:text-gray-600"
              >
                <FiMenu className="w-6 h-6" />
              </button>
              <h1 className="ml-2 text-2xl font-semibold text-gray-900 capitalize">
                {location.pathname.slice(1) || 'Dashboard'}
              </h1>
            </div>

            <div className="flex items-center space-x-4">
              {/* Notifications */}
              <button className="p-2 text-gray-400 hover:text-gray-600 relative">
                <FiBell className="w-6 h-6" />
                <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
              </button>

              {/* Profile Dropdown */}
              <div className="relative">
                <button
                  onClick={() => setProfileDropdownOpen(!profileDropdownOpen)}
                  className="flex items-center p-2 text-gray-400 hover:text-gray-600"
                >
                  <div className="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
                    <FiUser className="w-4 h-4" />
                  </div>
                </button>

                {profileDropdownOpen && (
                  <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-50">
                    <div className="px-4 py-2 border-b border-gray-100">
                      <p className="text-sm font-medium text-gray-900">{user?.name}</p>
                      <p className="text-xs text-gray-500">{user?.email}</p>
                    </div>
                    <button
                      onClick={handleLogout}
                      className="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      <FiLogOut className="w-4 h-4 mr-2" />
                      Sign out
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 p-6">
          {children}
        </main>
      </div>

      {/* Mobile Sidebar Overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black bg-opacity-50 lg:hidden"
          onClick={() => dispatch(toggleSidebar())}
        />
      )}

      {/* Delete Confirmation Modal */}
      <DeleteConfirmModal />
    </div>
  );
};

export default Layout;
