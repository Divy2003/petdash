import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  FiPlus,
  FiEdit,
  FiTrash2,
  FiRefreshCw,
  FiSettings,
  FiEye,
  FiEyeOff,
  FiSearch,
  FiFilter
} from 'react-icons/fi';
import { toast } from 'react-hot-toast';
import {
  fetchCategories,
  openCategoryForm,
  seedCategories
} from '../../redux/slices/categoriesSlice';
import CategoryFormModal from '../../components/CategoryFormModal/CategoryFormModal';
import { openDeleteConfirm } from '../../redux/slices/uiSlice';
import { getImageUrl, handleImageError } from '../../utils/imageUtils';
import './Categories.css';

const Categories = () => {
  const dispatch = useDispatch();
  const { categories, loading } = useSelector((state) => state.categories);
  const [filter, setFilter] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [viewMode, setViewMode] = useState('grid'); // 'grid' or 'table'

  useEffect(() => {
    dispatch(fetchCategories());
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(fetchCategories());
  };

  const handleCreateCategory = () => {
    dispatch(openCategoryForm({ mode: 'create' }));
  };

  const handleEditCategory = (category) => {
    dispatch(openCategoryForm({ mode: 'edit', data: category }));
  };

  const handleDeleteCategory = (category) => {
    dispatch(openDeleteConfirm({
      title: 'Delete Category',
      message: `Are you sure you want to delete "${category.name}"? This action cannot be undone.`,
      entityType: 'category',
      entityId: category._id,
      entityData: category
    }));
  };

  const handleSeedCategories = async () => {
    try {
      await dispatch(seedCategories()).unwrap();
      toast.success('Default categories created successfully');
      dispatch(fetchCategories());
    } catch (error) {
      toast.error(error || 'Failed to seed categories');
    }
  };

  const filteredCategories = categories.filter(category => {
    // Filter by status
    let statusMatch = true;
    if (filter === 'active') statusMatch = category.isActive;
    if (filter === 'inactive') statusMatch = !category.isActive;
    if (filter === 'featured') statusMatch = category.isFeatured;

    // Filter by search term
    const searchMatch = searchTerm === '' ||
      category.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      category.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (category.tags && category.tags.some(tag =>
        tag.toLowerCase().includes(searchTerm.toLowerCase())
      ));

    return statusMatch && searchMatch;
  }).sort((a, b) => {
    // Sort by featured first, then by order, then by name
    if (a.isFeatured && !b.isFeatured) return -1;
    if (!a.isFeatured && b.isFeatured) return 1;
    if (a.order !== b.order) return (a.order || 0) - (b.order || 0);
    return a.name.localeCompare(b.name);
  });

  const getStatusBadge = (isActive) => {
    return (
      <span className={`category-status-badge ${isActive ? 'active' : 'inactive'}`}>
        {isActive ? 'Active' : 'Inactive'}
      </span>
    );
  };

  return (
    <div className="categories-page">
      {/* Header Section */}
      <div className="categories-header">
        <div className="header-content">
          <div className="header-text">
            <h1 className="page-title">Categories Management</h1>
            <p className="page-subtitle">Manage service categories for your platform</p>
          </div>
          <div className="header-actions">
            <button
              onClick={handleSeedCategories}
              disabled={loading}
              className="btn btn-secondary"
              title="Create default categories"
            >
              <FiSettings className="btn-icon" />
              Seed Default
            </button>
            <button
              onClick={handleRefresh}
              disabled={loading}
              className="btn btn-secondary"
              title="Refresh categories"
            >
              <FiRefreshCw className={`btn-icon ${loading ? 'animate-spin' : ''}`} />
              Refresh
            </button>
            <button
              onClick={handleCreateCategory}
              className="btn btn-primary"
              title="Create new category"
            >
              <FiPlus className="btn-icon" />
              Create Category
            </button>
          </div>
        </div>
      </div>

      {/* Stats Section */}
      <div className="stats-section">
        <div className="stats-grid">
          <div className="stat-card total">
            <div className="stat-icon">📊</div>
            <div className="stat-content">
              <div className="stat-number">{categories.length}</div>
              <div className="stat-label">Total Categories</div>
            </div>
          </div>
          <div className="stat-card active">
            <div className="stat-icon">✅</div>
            <div className="stat-content">
              <div className="stat-number">{categories.filter(c => c.isActive).length}</div>
              <div className="stat-label">Active Categories</div>
            </div>
          </div>
          <div className="stat-card featured">
            <div className="stat-icon">⭐</div>
            <div className="stat-content">
              <div className="stat-number">{categories.filter(c => c.isFeatured).length}</div>
              <div className="stat-label">Featured Categories</div>
            </div>
          </div>
          <div className="stat-card inactive">
            <div className="stat-icon">❌</div>
            <div className="stat-content">
              <div className="stat-number">{categories.filter(c => !c.isActive).length}</div>
              <div className="stat-label">Inactive Categories</div>
            </div>
          </div>
        </div>
      </div>

      {/* Search and Filters Section */}
      <div className="controls-section">
        <div className="search-container">
          <div className="search-input-wrapper">
            <FiSearch className="search-icon" />
            <input
              type="text"
              placeholder="Search categories by name, description, or tags..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
            />
          </div>
        </div>

        <div className="filters-container">
          <div className="filter-group">
            <FiFilter className="filter-icon" />
            <span className="filter-label">Filter:</span>
            <div className="filter-buttons">
              {[
                { key: 'all', label: 'All Categories', icon: '📁' },
                { key: 'active', label: 'Active Only', icon: '✅' },
                { key: 'featured', label: 'Featured Only', icon: '⭐' },
                { key: 'inactive', label: 'Inactive Only', icon: '❌' }
              ].map(({ key, label, icon }) => (
                <button
                  key={key}
                  onClick={() => setFilter(key)}
                  className={`filter-btn ${filter === key ? 'active' : ''}`}
                  title={label}
                >
                  <span className="filter-btn-icon">{icon}</span>
                  <span className="filter-btn-text">{label}</span>
                </button>
              ))}
            </div>
          </div>

          <div className="view-toggle">
            <button
              onClick={() => setViewMode('grid')}
              className={`view-btn ${viewMode === 'grid' ? 'active' : ''}`}
              title="Grid View"
            >
              <span>🔲</span>
            </button>
            <button
              onClick={() => setViewMode('table')}
              className={`view-btn ${viewMode === 'table' ? 'active' : ''}`}
              title="Table View"
            >
              <span>📋</span>
            </button>
          </div>
        </div>
      </div>

      {/* Categories Display Section */}
      <div className="categories-section">
        <div className="section-header">
          <h3 className="section-title">
            Categories ({filteredCategories.length})
          </h3>
          {searchTerm && (
            <span className="search-results">
              Showing results for "{searchTerm}"
            </span>
          )}
        </div>

        <div className="section-content">
          {loading ? (
            <div className="loading-state">
              <div className="spinner"></div>
              <span className="loading-text">Loading categories...</span>
            </div>
          ) : filteredCategories.length === 0 ? (
            <div className="empty-state">
              <div className="empty-icon">
                {searchTerm ? '🔍' : '📁'}
              </div>
              <h4 className="empty-title">
                {searchTerm
                  ? 'No categories found'
                  : filter === 'all'
                    ? 'No categories available'
                    : `No ${filter} categories found`
                }
              </h4>
              <p className="empty-description">
                {searchTerm
                  ? 'Try adjusting your search terms or filters'
                  : 'Get started by creating your first category'
                }
              </p>
              {categories.length === 0 && !searchTerm && (
                <button
                  onClick={handleSeedCategories}
                  className="btn btn-primary"
                >
                  Create Default Categories
                </button>
              )}
            </div>
          ) : (
            <div className={`categories-display ${viewMode}`}>
              {viewMode === 'grid' ? (
                <div className="categories-grid">
                  {filteredCategories.map((category) => (
                    <div
                      key={category._id}
                      className={`category-card ${category.isFeatured ? 'featured' : ''}`}
                      style={{
                        backgroundColor: category.color || '#f8f9fa',
                        color: category.textColor || '#374151'
                      }}
                    >
                      {/* Card Header */}
                      <div className="category-card-header">
                        <div className="category-info">
                          <div className="category-icon-wrapper">
                            {category.image ? (
                              <img
                                src={getImageUrl(category.image)}
                                alt={category.name}
                                className="category-image"
                                onError={(e) => handleImageError(e, 'category')}
                              />
                            ) : (
                              <div className="category-icon-placeholder">
                                <span className="category-icon">{category.icon || '📁'}</span>
                              </div>
                            )}
                          </div>
                          <div className="category-details">
                            <div className="category-title-row">
                              <h4 className="category-name">{category.name}</h4>
                              {category.isFeatured && (
                                <span className="featured-badge">
                                  ⭐ Featured
                                </span>
                              )}
                            </div>
                            {getStatusBadge(category.isActive)}
                          </div>
                        </div>
                        <div className="category-actions">
                          <button
                            onClick={() => handleEditCategory(category)}
                            className="action-btn edit"
                            title="Edit Category"
                          >
                            <FiEdit />
                          </button>
                          <button
                            onClick={() => handleDeleteCategory(category)}
                            className="action-btn delete"
                            title="Delete Category"
                          >
                            <FiTrash2 />
                          </button>
                        </div>
                      </div>

                      {/* Card Content */}
                      <div className="category-card-content">
                        {category.shortDescription && (
                          <p className="category-short-description">
                            {category.shortDescription}
                          </p>
                        )}

                        <p className="category-description">
                          {category.description}
                        </p>

                        {/* Tags */}
                        {category.tags && category.tags.length > 0 && (
                          <div className="category-tags">
                            {category.tags.slice(0, 3).map((tag, index) => (
                              <span key={index} className="category-tag">
                                {tag}
                              </span>
                            ))}
                            {category.tags.length > 3 && (
                              <span className="category-tag more">
                                +{category.tags.length - 3}
                              </span>
                            )}
                          </div>
                        )}
                      </div>

                      {/* Card Footer */}
                      <div className="category-card-footer">
                        <div className="category-meta">
                          <span className="meta-item">Order: {category.order || 0}</span>
                          {category.serviceCount !== undefined && (
                            <span className="meta-item">Services: {category.serviceCount}</span>
                          )}
                        </div>
                        <div className="category-visibility">
                          {category.isActive ? (
                            <FiEye className="visibility-icon" />
                          ) : (
                            <FiEyeOff className="visibility-icon" />
                          )}
                          <span className="visibility-text">
                            {category.isActive ? 'Visible' : 'Hidden'}
                          </span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="categories-table">
                  <table className="table">
                    <thead>
                      <tr>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Order</th>
                        <th>Services</th>
                        <th>Tags</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredCategories.map((category) => (
                        <tr key={category._id}>
                          <td>
                            <div className="table-category-info">
                              <div className="table-category-icon">
                                {category.image ? (
                                  <img
                                    src={getImageUrl(category.image)}
                                    alt={category.name}
                                    className="table-category-image"
                                    onError={(e) => handleImageError(e, 'category')}
                                  />
                                ) : (
                                  <span className="table-icon">{category.icon || '📁'}</span>
                                )}
                              </div>
                              <div className="table-category-details">
                                <div className="table-category-name">
                                  {category.name}
                                  {category.isFeatured && (
                                    <span className="table-featured-badge">⭐</span>
                                  )}
                                </div>
                                <div className="table-category-description">
                                  {category.shortDescription || category.description}
                                </div>
                              </div>
                            </div>
                          </td>
                          <td>
                            {getStatusBadge(category.isActive)}
                          </td>
                          <td>
                            <span className="table-order">{category.order || 0}</span>
                          </td>
                          <td>
                            <span className="table-services">{category.serviceCount || 0}</span>
                          </td>
                          <td>
                            <div className="table-tags">
                              {category.tags && category.tags.length > 0 ? (
                                category.tags.slice(0, 2).map((tag, index) => (
                                  <span key={index} className="table-tag">
                                    {tag}
                                  </span>
                                ))
                              ) : (
                                <span className="table-no-tags">No tags</span>
                              )}
                              {category.tags && category.tags.length > 2 && (
                                <span className="table-tag-more">
                                  +{category.tags.length - 2}
                                </span>
                              )}
                            </div>
                          </td>
                          <td>
                            <div className="table-actions">
                              <button
                                onClick={() => handleEditCategory(category)}
                                className="table-action-btn edit"
                                title="Edit Category"
                              >
                                <FiEdit />
                              </button>
                              <button
                                onClick={() => handleDeleteCategory(category)}
                                className="table-action-btn delete"
                                title="Delete Category"
                              >
                                <FiTrash2 />
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Category Form Modal */}
      <CategoryFormModal />
    </div>
  );
};

export default Categories;
