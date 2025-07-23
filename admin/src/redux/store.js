import { configureStore } from '@reduxjs/toolkit';
import authSlice from './slices/authSlice';
import usersSlice from './slices/usersSlice';
import coursesSlice from './slices/coursesSlice';
import analyticsSlice from './slices/analyticsSlice';
import categoriesSlice from './slices/categoriesSlice';
import uiSlice from './slices/uiSlice';

export const store = configureStore({
  reducer: {
    auth: authSlice,
    users: usersSlice,
    courses: coursesSlice,
    analytics: analyticsSlice,
    categories: categoriesSlice,
    ui: uiSlice,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['persist/PERSIST'],
      },
    }),
});

export default store;
