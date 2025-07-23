import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { categoriesAPI } from '../../services/api';

// Async thunks
export const fetchCategories = createAsyncThunk(
  'categories/fetchCategories',
  async (_, { rejectWithValue }) => {
    try {
      const response = await categoriesAPI.getAllCategoriesAdmin();
      return response.data.categories;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const fetchCategoryById = createAsyncThunk(
  'categories/fetchCategoryById',
  async (id, { rejectWithValue }) => {
    try {
      const response = await categoriesAPI.getCategoryById(id);
      return response.data.category;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const createCategory = createAsyncThunk(
  'categories/createCategory',
  async (categoryData, { rejectWithValue }) => {
    try {
      // If image is a preview string, convert to File if possible (should be a File from input)
      const response = await categoriesAPI.createCategory(categoryData);
      return response.data.category;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const updateCategory = createAsyncThunk(
  'categories/updateCategory',
  async ({ id, data }, { rejectWithValue }) => {
    try {
      const response = await categoriesAPI.updateCategory(id, data);
      return response.data.category;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const deleteCategory = createAsyncThunk(
  'categories/deleteCategory',
  async (id, { rejectWithValue }) => {
    try {
      await categoriesAPI.deleteCategory(id);
      return id;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

export const seedCategories = createAsyncThunk(
  'categories/seedCategories',
  async (_, { rejectWithValue }) => {
    try {
      const response = await categoriesAPI.seedCategories();
      return response.data.createdCategories;
    } catch (error) {
      return rejectWithValue(error.response?.data?.message || error.message);
    }
  }
);

const initialState = {
  categories: [],
  selectedCategory: null,
  loading: false,
  error: null,
  categoryForm: {
    isOpen: false,
    mode: 'create', // 'create' or 'edit'
    data: null,
  },
};

const categoriesSlice = createSlice({
  name: 'categories',
  initialState,
  reducers: {
    clearSelectedCategory: (state) => {
      state.selectedCategory = null;
    },
    clearError: (state) => {
      state.error = null;
    },
    openCategoryForm: (state, action) => {
      state.categoryForm.isOpen = true;
      state.categoryForm.mode = action.payload.mode;
      state.categoryForm.data = action.payload.data || null;
    },
    closeCategoryForm: (state) => {
      state.categoryForm.isOpen = false;
      state.categoryForm.mode = 'create';
      state.categoryForm.data = null;
    },
    updateCategoryInList: (state, action) => {
      const index = state.categories.findIndex(category => category._id === action.payload._id);
      if (index !== -1) {
        state.categories[index] = action.payload;
      }
    },
  },
  extraReducers: (builder) => {
    builder
      // Fetch categories
      .addCase(fetchCategories.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCategories.fulfilled, (state, action) => {
        state.loading = false;
        state.categories = action.payload || [];
      })
      .addCase(fetchCategories.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Fetch category by ID
      .addCase(fetchCategoryById.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCategoryById.fulfilled, (state, action) => {
        state.loading = false;
        state.selectedCategory = action.payload;
      })
      .addCase(fetchCategoryById.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Create category
      .addCase(createCategory.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createCategory.fulfilled, (state, action) => {
        state.loading = false;
        state.categories.unshift(action.payload);
        state.categoryForm.isOpen = false;
      })
      .addCase(createCategory.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Update category
      .addCase(updateCategory.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(updateCategory.fulfilled, (state, action) => {
        state.loading = false;
        const index = state.categories.findIndex(category => category._id === action.payload._id);
        if (index !== -1) {
          state.categories[index] = action.payload;
        }
        state.categoryForm.isOpen = false;
      })
      .addCase(updateCategory.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Delete category
      .addCase(deleteCategory.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(deleteCategory.fulfilled, (state, action) => {
        state.loading = false;
        state.categories = state.categories.filter(category => category._id !== action.payload);
      })
      .addCase(deleteCategory.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      })
      
      // Seed categories
      .addCase(seedCategories.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(seedCategories.fulfilled, (state, action) => {
        state.loading = false;
        // Add new categories to the list
        if (action.payload && action.payload.length > 0) {
          state.categories = [...state.categories, ...action.payload];
        }
      })
      .addCase(seedCategories.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export const { 
  clearSelectedCategory, 
  clearError, 
  openCategoryForm, 
  closeCategoryForm,
  updateCategoryInList 
} = categoriesSlice.actions;

export default categoriesSlice.reducer;
