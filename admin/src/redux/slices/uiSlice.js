import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  sidebarOpen: true,
  theme: 'light',
  notifications: [],
  modals: {
    deleteConfirm: {
      isOpen: false,
      title: '',
      message: '',
      entityType: null, // 'category', 'course', etc.
      entityId: null,
      entityData: null, // Additional data needed for deletion
      loading: false,
    },
    roleManagement: {
      isOpen: false,
      user: null,
    },
    courseForm: {
      isOpen: false,
      mode: 'create',
      course: null,
    },
  },
  loading: {
    global: false,
    users: false,
    courses: false,
    analytics: false,
  },
};

const uiSlice = createSlice({
  name: 'ui',
  initialState,
  reducers: {
    toggleSidebar: (state) => {
      state.sidebarOpen = !state.sidebarOpen;
    },
    setSidebarOpen: (state, action) => {
      state.sidebarOpen = action.payload;
    },
    setTheme: (state, action) => {
      state.theme = action.payload;
    },
    addNotification: (state, action) => {
      const notification = {
        id: Date.now(),
        type: 'info',
        title: '',
        message: '',
        duration: 5000,
        ...action.payload,
      };
      state.notifications.push(notification);
    },
    removeNotification: (state, action) => {
      state.notifications = state.notifications.filter(
        notification => notification.id !== action.payload
      );
    },
    clearNotifications: (state) => {
      state.notifications = [];
    },
    openDeleteConfirm: (state, action) => {
      state.modals.deleteConfirm = {
        isOpen: true,
        title: action.payload.title || 'Confirm Delete',
        message: action.payload.message || 'Are you sure you want to delete this item?',
        entityType: action.payload.entityType,
        entityId: action.payload.entityId,
        entityData: action.payload.entityData || null,
        loading: false,
      };
    },
    closeDeleteConfirm: (state) => {
      state.modals.deleteConfirm = {
        isOpen: false,
        title: '',
        message: '',
        entityType: null,
        entityId: null,
        entityData: null,
        loading: false,
      };
    },
    setDeleteConfirmLoading: (state, action) => {
      state.modals.deleteConfirm.loading = action.payload;
    },
    openRoleManagement: (state, action) => {
      state.modals.roleManagement = {
        isOpen: true,
        user: action.payload,
      };
    },
    closeRoleManagement: (state) => {
      state.modals.roleManagement = {
        isOpen: false,
        user: null,
      };
    },
    openCourseForm: (state, action) => {
      state.modals.courseForm = {
        isOpen: true,
        mode: action.payload.mode || 'create',
        course: action.payload.course || null,
      };
    },
    closeCourseForm: (state) => {
      state.modals.courseForm = {
        isOpen: false,
        mode: 'create',
        course: null,
      };
    },
    setLoading: (state, action) => {
      const { key, value } = action.payload;
      if (key in state.loading) {
        state.loading[key] = value;
      }
    },
    setGlobalLoading: (state, action) => {
      state.loading.global = action.payload;
    },
  },
});

export const {
  toggleSidebar,
  setSidebarOpen,
  setTheme,
  addNotification,
  removeNotification,
  clearNotifications,
  openDeleteConfirm,
  closeDeleteConfirm,
  setDeleteConfirmLoading,
  openRoleManagement,
  closeRoleManagement,
  openCourseForm,
  closeCourseForm,
  setLoading,
  setGlobalLoading,
} = uiSlice.actions;

export default uiSlice.reducer;
