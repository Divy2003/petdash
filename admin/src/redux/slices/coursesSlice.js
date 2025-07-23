import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { coursesAPI } from '../../services/api';

// Async thunks
export const fetchCourses = createAsyncThunk(
  'courses/fetchCourses',
  async (params = {}, { rejectWithValue }) => {
    try {
      const response = await coursesAPI.getAllCourses(params);
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const fetchCourseById = createAsyncThunk(
  'courses/fetchCourseById',
  async (id, { rejectWithValue }) => {
    try {
      const response = await coursesAPI.getCourseById(id);
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const createCourse = createAsyncThunk(
  'courses/createCourse',
  async (courseData, { rejectWithValue }) => {
    try {
      const response = await coursesAPI.createCourse(courseData);
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const updateCourse = createAsyncThunk(
  'courses/updateCourse',
  async ({ id, data }, { rejectWithValue }) => {
    try {
      const response = await coursesAPI.updateCourse(id, data);
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const deleteCourse = createAsyncThunk(
  'courses/deleteCourse',
  async (id, { rejectWithValue }) => {
    try {
      await coursesAPI.deleteCourse(id);
      return id;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const fetchCourseCategories = createAsyncThunk(
  'courses/fetchCourseCategories',
  async (_, { rejectWithValue }) => {
    try {
      const response = await coursesAPI.getCourseCategories();
      return response.data.categories;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

const initialState = {
  courses: [],
  selectedCourse: null,
  categories: [],
  loading: false,
  error: null,
  pagination: {
    currentPage: 1,
    totalPages: 1,
    totalCourses: 0,
    hasNext: false,
    hasPrev: false,
  },
  filters: {
    search: '',
    category: '',
    difficulty: '',
    trainingType: 'online',
    status: '',
    page: 1,
    limit: 10,
  },
  courseForm: {
    isOpen: false,
    mode: 'create', // 'create' or 'edit'
    data: null,
  },
};

const coursesSlice = createSlice({
  name: 'courses',
  initialState,
  reducers: {
    setFilters: (state, action) => {
      state.filters = { ...state.filters, ...action.payload };
    },
    clearSelectedCourse: (state) => {
      state.selectedCourse = null;
    },
    clearError: (state) => {
      state.error = null;
    },
    openCourseForm: (state, action) => {
      state.courseForm.isOpen = true;
      state.courseForm.mode = action.payload.mode;
      state.courseForm.data = action.payload.data || null;
    },
    closeCourseForm: (state) => {
      state.courseForm.isOpen = false;
      state.courseForm.mode = 'create';
      state.courseForm.data = null;
    },
    updateCourseInList: (state, action) => {
      const index = state.courses.findIndex(course => course._id === action.payload._id);
      if (index !== -1) {
        state.courses[index] = action.payload;
      }
    },
  },
  extraReducers: (builder) => {
    builder
      // Fetch courses
      .addCase(fetchCourses.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCourses.fulfilled, (state, action) => {
        state.loading = false;
        state.courses = action.payload.courses || [];
        state.pagination = action.payload.pagination || state.pagination;
      })
      .addCase(fetchCourses.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Fetch course by ID
      .addCase(fetchCourseById.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCourseById.fulfilled, (state, action) => {
        state.loading = false;
        state.selectedCourse = action.payload.course || action.payload;
      })
      .addCase(fetchCourseById.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Create course
      .addCase(createCourse.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createCourse.fulfilled, (state, action) => {
        state.loading = false;
        state.courses.unshift(action.payload.course || action.payload);
        state.courseForm.isOpen = false;
      })
      .addCase(createCourse.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Update course
      .addCase(updateCourse.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(updateCourse.fulfilled, (state, action) => {
        state.loading = false;
        const updatedCourse = action.payload.course || action.payload;
        const index = state.courses.findIndex(course => course._id === updatedCourse._id);
        if (index !== -1) {
          state.courses[index] = updatedCourse;
        }
        state.courseForm.isOpen = false;
      })
      .addCase(updateCourse.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Delete course
      .addCase(deleteCourse.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(deleteCourse.fulfilled, (state, action) => {
        state.loading = false;
        state.courses = state.courses.filter(course => course._id !== action.payload);
      })
      .addCase(deleteCourse.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Fetch categories
      .addCase(fetchCourseCategories.fulfilled, (state, action) => {
        state.categories = action.payload;
      });
  },
});

export const { 
  setFilters, 
  clearSelectedCourse, 
  clearError, 
  openCourseForm, 
  closeCourseForm,
  updateCourseInList 
} = coursesSlice.actions;

export default coursesSlice.reducer;
