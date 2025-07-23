
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Provider } from 'react-redux';
import { Toaster } from 'react-hot-toast';
import store from './redux/store';
import Layout from './components/Layout/Layout';
import Login from './pages/Login/Login';
import Dashboard from './pages/Dashboard/Dashboard';
import Users from './pages/Users/Users';
import Courses from './pages/Courses/Courses';
import Categories from './pages/Categories/Categories';
import Analytics from './pages/Analytics/Analytics';
import RoleManagement from './pages/RoleManagement/RoleManagement';
import ProtectedRoute from './components/ProtectedRoute/ProtectedRoute';
import './styles/admin.css';

function App() {
  return (
    <Provider store={store}>
      <Router>
        <div className="App">
          <Toaster
            position="top-right"
            toastOptions={{
              duration: 4000,
              style: {
                background: '#363636',
                color: '#fff',
              },
              success: {
                duration: 3000,
                theme: {
                  primary: 'green',
                  secondary: 'black',
                },
              },
            }}
          />

          <Routes>
            <Route path="/login" element={<Login />} />
            <Route
              path="/*"
              element={
                <ProtectedRoute>
                  <Layout>
                    <Routes>
                      <Route path="/" element={<Navigate to="/dashboard" replace />} />
                      <Route path="/dashboard" element={<Dashboard />} />
                      <Route path="/users" element={<Users />} />
                      <Route path="/courses" element={<Courses />} />
                      <Route path="/categories" element={<Categories />} />
                      <Route path="/analytics" element={<Analytics />} />
                      <Route path="/role-management" element={<RoleManagement />} />
                    </Routes>
                  </Layout>
                </ProtectedRoute>
              }
            />
          </Routes>
        </div>
      </Router>
    </Provider>
  );
}

export default App;
