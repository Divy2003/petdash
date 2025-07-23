import { useDispatch, useSelector } from 'react-redux';
import { FiAlertTriangle, FiX } from 'react-icons/fi';
import { toast } from 'react-hot-toast';
import { closeDeleteConfirm, setDeleteConfirmLoading } from '../../redux/slices/uiSlice';
import { deleteCategory } from '../../redux/slices/categoriesSlice';
import { deleteCourse } from '../../redux/slices/coursesSlice';

const DeleteConfirmModal = () => {
  const dispatch = useDispatch();
  const { modals } = useSelector((state) => state.ui);
  const { isOpen, title, message, entityType, entityId, entityData, loading } = modals.deleteConfirm;

  const handleConfirm = async () => {
    if (entityType && entityId) {
      dispatch(setDeleteConfirmLoading(true));
      try {
        switch (entityType) {
          case 'category':
            await dispatch(deleteCategory(entityId)).unwrap();
            toast.success('Category deleted successfully');
            break;
          case 'course':
            await dispatch(deleteCourse(entityId)).unwrap();
            toast.success('Course deleted successfully');
            break;
          default:
            toast.error('Unknown entity type');
            break;
        }
      } catch (error) {
        toast.error(error || `Failed to delete ${entityType}`);
      } finally {
        dispatch(setDeleteConfirmLoading(false));
        dispatch(closeDeleteConfirm());
      }
    }
  };

  const handleClose = () => {
    if (!loading) {
      dispatch(closeDeleteConfirm());
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        {/* Background overlay */}
        <div
          className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
          onClick={handleClose}
        />

        {/* Modal */}
        <div className="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          <div className="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div className="sm:flex sm:items-start">
              <div className="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                <FiAlertTriangle className="h-6 w-6 text-red-600" />
              </div>
              <div className="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left flex-1">
                <div className="flex items-center justify-between">
                  <h3 className="text-lg leading-6 font-medium text-gray-900">
                    {title}
                  </h3>
                  <button
                    onClick={handleClose}
                    disabled={loading}
                    className="text-gray-400 hover:text-gray-600"
                  >
                    <FiX className="w-5 h-5" />
                  </button>
                </div>
                <div className="mt-2">
                  <p className="text-sm text-gray-500">
                    {message}
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button
              onClick={handleConfirm}
              disabled={loading}
              className="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <div className="flex items-center">
                  <div className="spinner mr-2"></div>
                  Deleting...
                </div>
              ) : (
                'Delete'
              )}
            </button>
            <button
              onClick={handleClose}
              disabled={loading}
              className="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DeleteConfirmModal;
