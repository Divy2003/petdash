import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { authAPI } from '../../services/api';

// Async thunks
export const loginAdmin = createAsyncThunk(
  'auth/loginAdmin',
  async (credentials, { rejectWithValue }) => {
    try {
      const response = await authAPI.login(credentials);
      const { token, user } = response.data;
      
      // Check if user is admin
      if (user.userType !== 'Admin') {
        throw new Error('Access denied. Admin privileges required.');
      }
      
      localStorage.setItem('adminToken', token);
      localStorage.setItem('adminUser', JSON.stringify(user));
      
      return { token, user };
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const enableRoleSwitching = createAsyncThunk(
  'auth/enableRoleSwitching',
  async (data, { rejectWithValue }) => {
    try {
      const response = await authAPI.enableRoleSwitching(data);
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const bulkEnableRoles = createAsyncThunk(
  'auth/bulkEnableRoles',
  async (data, { rejectWithValue }) => {
    try {
      const response = await authAPI.bulkEnableRoles(data);
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const getRoleAnalytics = createAsyncThunk(
  'auth/getRoleAnalytics',
  async (_, { rejectWithValue }) => {
    try {
      const response = await authAPI.getRoleAnalytics();
      return response.data.analytics;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

const initialState = {
  user: JSON.parse(localStorage.getItem('adminUser')) || null,
  token: localStorage.getItem('adminToken') || null,
  isAuthenticated: !!localStorage.getItem('adminToken'),
  loading: false,
  error: null,
  roleAnalytics: null,
  roleOperationLoading: false,
};

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    logout: (state) => {
      state.user = null;
      state.token = null;
      state.isAuthenticated = false;
      state.roleAnalytics = null;
      localStorage.removeItem('adminToken');
      localStorage.removeItem('adminUser');
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      // Login
      .addCase(loginAdmin.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(loginAdmin.fulfilled, (state, action) => {
        state.loading = false;
        state.user = action.payload.user;
        state.token = action.payload.token;
        state.isAuthenticated = true;
      })
      .addCase(loginAdmin.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Enable role switching
      .addCase(enableRoleSwitching.pending, (state) => {
        state.roleOperationLoading = true;
        state.error = null;
      })
      .addCase(enableRoleSwitching.fulfilled, (state) => {
        state.roleOperationLoading = false;
      })
      .addCase(enableRoleSwitching.rejected, (state, action) => {
        state.roleOperationLoading = false;
        state.error = action.payload;
      })
      
      // Bulk enable roles
      .addCase(bulkEnableRoles.pending, (state) => {
        state.roleOperationLoading = true;
        state.error = null;
      })
      .addCase(bulkEnableRoles.fulfilled, (state) => {
        state.roleOperationLoading = false;
      })
      .addCase(bulkEnableRoles.rejected, (state, action) => {
        state.roleOperationLoading = false;
        state.error = action.payload;
      })
      
      // Get role analytics
      .addCase(getRoleAnalytics.pending, (state) => {
        state.loading = true;
      })
      .addCase(getRoleAnalytics.fulfilled, (state, action) => {
        state.loading = false;
        state.roleAnalytics = action.payload;
      })
      .addCase(getRoleAnalytics.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export const { logout, clearError } = authSlice.actions;
export default authSlice.reducer;
