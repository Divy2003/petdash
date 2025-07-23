import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { analyticsAPI } from '../../services/api';

// Async thunks
export const fetchSystemStats = createAsyncThunk(
  'analytics/fetchSystemStats',
  async (_, { rejectWithValue }) => {
    try {
      const response = await analyticsAPI.getSystemStats();
      return response.data.stats;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const fetchCourseAnalytics = createAsyncThunk(
  'analytics/fetchCourseAnalytics',
  async (_, { rejectWithValue }) => {
    try {
      const response = await analyticsAPI.getCourseAnalytics();
      return response.data.analytics;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const fetchRoleAnalytics = createAsyncThunk(
  'analytics/fetchRoleAnalytics',
  async (_, { rejectWithValue }) => {
    try {
      const response = await analyticsAPI.getRoleAnalytics();
      return response.data.analytics;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

const initialState = {
  systemStats: null,
  courseAnalytics: null,
  roleAnalytics: null,
  loading: false,
  error: null,
  lastUpdated: null,
};

const analyticsSlice = createSlice({
  name: 'analytics',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
    refreshAnalytics: (state) => {
      state.lastUpdated = new Date().toISOString();
    },
  },
  extraReducers: (builder) => {
    builder
      // System stats
      .addCase(fetchSystemStats.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchSystemStats.fulfilled, (state, action) => {
        state.loading = false;
        state.systemStats = action.payload;
        state.lastUpdated = new Date().toISOString();
      })
      .addCase(fetchSystemStats.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Course analytics
      .addCase(fetchCourseAnalytics.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCourseAnalytics.fulfilled, (state, action) => {
        state.loading = false;
        state.courseAnalytics = action.payload;
        state.lastUpdated = new Date().toISOString();
      })
      .addCase(fetchCourseAnalytics.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Role analytics
      .addCase(fetchRoleAnalytics.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchRoleAnalytics.fulfilled, (state, action) => {
        state.loading = false;
        state.roleAnalytics = action.payload;
        state.lastUpdated = new Date().toISOString();
      })
      .addCase(fetchRoleAnalytics.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export const { clearError, refreshAnalytics } = analyticsSlice.actions;
export default analyticsSlice.reducer;
