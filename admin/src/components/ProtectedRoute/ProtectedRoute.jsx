import { useSelector } from 'react-redux';
import './ProtectedRoute.css';
import { Navigate } from 'react-router-dom';

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, user } = useSelector((state) => state.auth);

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  // Check if user is admin
  if (!user || user.userType !== 'Admin') {
    return (
      <div className="protectedroute-outer">
        <div className="protectedroute-card">
          <h2 className="protectedroute-title">Access Denied</h2>
          <p className="protectedroute-desc">You need admin privileges to access this area.</p>
        </div>
      </div>
    );
  }

  return children;
};

export default ProtectedRoute;
