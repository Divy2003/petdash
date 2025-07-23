import axios from 'axios';

// Create axios instance with base configuration
const api = axios.create({
  baseURL: 'http://localhost:5000/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('adminToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('adminToken');
      localStorage.removeItem('adminUser');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth API
export const authAPI = {
  login: (credentials) => api.post('/auth/login', credentials),
  getRoleInfo: () => api.get('/auth/role-info'),
  enableRoleSwitching: (data) => api.post('/auth/enable-role-switching', data),
  bulkEnableRoles: (data) => api.post('/auth/admin/bulk-enable-roles', data),
  getRoleAnalytics: () => api.get('/auth/admin/role-analytics'),
};

// Users API
export const usersAPI = {
  getAllUsers: (params) => api.get('/users', { params }),
  getUserById: (id) => api.get(`/users/${id}`),
  updateUser: (id, data) => api.put(`/users/${id}`, data),
  deleteUser: (id) => api.delete(`/users/${id}`),
};

// Courses API
export const coursesAPI = {
  getAllCourses: (params) => api.get('/courses/admin/all', { params }),
  getCourseById: (id) => api.get(`/courses/${id}`),
  createCourse: (data) => api.post('/courses/admin/create', data),
  updateCourse: (id, data) => api.put(`/courses/admin/${id}`, data),
  deleteCourse: (id) => api.delete(`/courses/admin/${id}`),
  getCourseAnalytics: () => api.get('/courses/admin/analytics'),
  getCourseCategories: () => api.get('/courses/categories/list'),
};

// Analytics API
export const analyticsAPI = {
  getSystemStats: () => api.get('/admin/system-stats'),
  getCourseAnalytics: () => api.get('/courses/admin/analytics'),
  getRoleAnalytics: () => api.get('/auth/admin/role-analytics'),
};

// Services API
export const servicesAPI = {
  getAllServices: (params) => api.get('/services', { params }),
  getServiceById: (id) => api.get(`/services/${id}`),
  deleteService: (id) => api.delete(`/services/${id}`),
};

// Appointments API
export const appointmentsAPI = {
  getAllAppointments: (params) => api.get('/appointments', { params }),
  getAppointmentById: (id) => api.get(`/appointments/${id}`),
  updateAppointmentStatus: (id, status) => api.put(`/appointments/${id}/status`, { status }),
};

// Products API
export const productsAPI = {
  getAllProducts: (params) => api.get('/products', { params }),
  getProductById: (id) => api.get(`/products/${id}`),
  deleteProduct: (id) => api.delete(`/products/${id}`),
};

// Reviews API
export const reviewsAPI = {
  getAllReviews: (params) => api.get('/reviews', { params }),
  getReviewById: (id) => api.get(`/reviews/${id}`),
  deleteReview: (id) => api.delete(`/reviews/${id}`),
};

// Adoption API
export const adoptionAPI = {
  getAllAdoptions: (params) => api.get('/adoption', { params }),
  getAdoptionById: (id) => api.get(`/adoption/${id}`),
  deleteAdoption: (id) => api.delete(`/adoption/${id}`),
};

// Categories API
export const categoriesAPI = {
  getAllCategories: () => api.get('/category/public'),
  getAllCategoriesAdmin: () => api.get('/category/admin/all'),
  getCategoryById: (id) => api.get(`/category/${id}`),
  createCategory: (data) => {
  const formData = new FormData();
  Object.entries(data).forEach(([key, value]) => {
    if (key === 'tags' && Array.isArray(value)) {
      value.forEach((tag, i) => formData.append(`tags[${i}]`, tag));
    } else if (key === 'image' && value instanceof File) {
      formData.append('image', value);
    } else {
      formData.append(key, value);
    }
  });
  return api.post('/category/create', formData, {
    headers: { 'Content-Type': undefined },
  });
},
  updateCategory: (id, data) => {
  const formData = new FormData();
  Object.entries(data).forEach(([key, value]) => {
    if (key === 'tags' && Array.isArray(value)) {
      value.forEach((tag, i) => formData.append(`tags[${i}]`, tag));
    } else if (key === 'image' && value instanceof File) {
      formData.append('image', value);
    } else {
      formData.append(key, value);
    }
  });
  return api.put(`/category/update/${id}`, formData, {
    headers: { 'Content-Type': undefined },
  });
},
  deleteCategory: (id) => api.delete(`/category/delete/${id}`),
  seedCategories: () => api.post('/category/seed'),
};

export default api;
