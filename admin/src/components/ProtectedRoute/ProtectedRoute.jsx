import { useSelector } from 'react-redux';
import { Navigate } from 'react-router-dom';

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, user } = useSelector((state) => state.auth);

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  // Check if user is admin
  if (!user || user.userType !== 'Admin') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="card p-6 text-center">
          <h2 className="text-xl font-semibold text-red-600 mb-2">Access Denied</h2>
          <p className="text-gray-600">You need admin privileges to access this area.</p>
        </div>
      </div>
    );
  }

  return children;
};

export default ProtectedRoute;
