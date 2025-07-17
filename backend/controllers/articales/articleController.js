const Article = require('../../models/Article');
const User = require('../../models/User');
const Product = require('../../models/Product');

// Create new article (Business owners only)
exports.createArticle = async (req, res) => {
  try {
    const {
      title,
      category,
      body,
      tags,
      relatedProducts,
      excerpt,
      status = 'draft'
    } = req.body;
    
    const authorId = req.user.id;
    
    // Validate user type - only Business owners can create articles
    const author = await User.findById(authorId);
    if (!author || author.userType !== 'Business') {
      return res.status(403).json({
        message: 'Only business owners can create articles'
      });
    }
    
    // Create article object
    const articleData = {
      author: authorId,
      title,
      category,
      body,
      status,
      excerpt: excerpt || body.substring(0, 200) + '...' // Auto-generate excerpt if not provided
    };
    
    // Add optional fields
    if (tags && Array.isArray(tags)) {
      articleData.tags = tags;
    }
    
    if (relatedProducts && Array.isArray(relatedProducts)) {
      articleData.relatedProducts = relatedProducts;
    }
    
    // Add featured image if uploaded
    if (req.files && req.files.featuredImage) {
      articleData.featuredImage = req.files.featuredImage[0].path;
    }
    
    // Add additional images if uploaded
    if (req.files && req.files.images) {
      articleData.images = req.files.images.map(file => file.path);
    }
    
    // Create and save the article
    const newArticle = new Article(articleData);
    await newArticle.save();
    
    // Populate author information
    await newArticle.populate('author', 'name shopImage');
    
    res.status(201).json({
      message: 'Article created successfully',
      article: newArticle
    });
    
  } catch (error) {
    console.error('Create article error:', error);
    res.status(500).json({
      message: 'Error creating article',
      error: error.message
    });
  }
};

// Get all published articles (Public)
exports.getPublishedArticles = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      category,
      tags,
      search,
      author
    } = req.query;
    
    // Build filter object
    let filter = {
      status: 'published',
      isActive: true,
      publishedAt: { $lte: new Date() }
    };
    
    if (category) {
      filter.category = category;
    }
    
    if (tags) {
      filter.tags = { $in: tags.split(',') };
    }
    
    if (author) {
      filter.author = author;
    }
    
    // Build search query
    let query = Article.find(filter);
    
    if (search) {
      query = Article.find({
        ...filter,
        $text: { $search: search }
      });
    }
    
    // Execute query with pagination
    const articles = await query
      .populate('author', 'name shopImage')
      .populate('relatedProducts', 'name price images')
      .sort({ publishedAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit))
      .select('title excerpt featuredImage views likes publishedAt author category tags'); // Select only needed fields for list view
    
    // Get total count
    const total = await Article.countDocuments(filter);
    
    res.status(200).json({
      message: 'Articles fetched successfully',
      articles,
      pagination: {
        total,
        page: parseInt(page),
        pages: Math.ceil(total / limit),
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
    
  } catch (error) {
    console.error('Get published articles error:', error);
    res.status(500).json({
      message: 'Error fetching articles',
      error: error.message
    });
  }
};

// Get single article by ID (Public)
exports.getArticleById = async (req, res) => {
  try {
    const { articleId } = req.params;
    
    const article = await Article.findOne({
      _id: articleId,
      status: 'published',
      isActive: true
    })
    .populate('author', 'name shopImage email phoneNumber')
    .populate('relatedProducts', 'name price images description');
    
    if (!article) {
      return res.status(404).json({
        message: 'Article not found'
      });
    }
    
    // Increment view count
    await article.incrementViews();
    
    res.status(200).json({
      message: 'Article fetched successfully',
      article
    });
    
  } catch (error) {
    console.error('Get article error:', error);
    res.status(500).json({
      message: 'Error fetching article',
      error: error.message
    });
  }
};

// Get articles by business owner (Business owner only)
exports.getMyArticles = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      status,
      category
    } = req.query;
    
    const authorId = req.user.id;
    
    // Build filter
    let filter = { author: authorId, isActive: true };
    
    if (status) {
      filter.status = status;
    }
    
    if (category) {
      filter.category = category;
    }
    
    // Get articles with pagination
    const articles = await Article.find(filter)
      .populate('relatedProducts', 'name price')
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));
    
    // Get total count
    const total = await Article.countDocuments(filter);
    
    res.status(200).json({
      message: 'My articles fetched successfully',
      articles,
      pagination: {
        total,
        page: parseInt(page),
        pages: Math.ceil(total / limit)
      }
    });
    
  } catch (error) {
    console.error('Get my articles error:', error);
    res.status(500).json({
      message: 'Error fetching articles',
      error: error.message
    });
  }
};

// Update article (Author only)
exports.updateArticle = async (req, res) => {
  try {
    const { articleId } = req.params;
    const {
      title,
      category,
      body,
      tags,
      relatedProducts,
      excerpt,
      status
    } = req.body;
    
    const userId = req.user.id;
    
    // Find the article
    const article = await Article.findById(articleId);
    
    if (!article) {
      return res.status(404).json({
        message: 'Article not found'
      });
    }
    
    // Check if user is the author
    if (article.author.toString() !== userId) {
      return res.status(403).json({
        message: 'You can only edit your own articles'
      });
    }
    
    // Update fields
    if (title) article.title = title;
    if (category) article.category = category;
    if (body) article.body = body;
    if (excerpt) article.excerpt = excerpt;
    if (status) article.status = status;
    
    if (tags && Array.isArray(tags)) {
      article.tags = tags;
    }
    
    if (relatedProducts && Array.isArray(relatedProducts)) {
      article.relatedProducts = relatedProducts;
    }
    
    // Update featured image if uploaded
    if (req.files && req.files.featuredImage) {
      article.featuredImage = req.files.featuredImage[0].path;
    }
    
    // Update additional images if uploaded
    if (req.files && req.files.images) {
      article.images = req.files.images.map(file => file.path);
    }
    
    await article.save();
    
    // Populate and return updated article
    await article.populate('author', 'name shopImage');
    await article.populate('relatedProducts', 'name price images');
    
    res.status(200).json({
      message: 'Article updated successfully',
      article
    });
    
  } catch (error) {
    console.error('Update article error:', error);
    res.status(500).json({
      message: 'Error updating article',
      error: error.message
    });
  }
};

// Delete article (Author only)
exports.deleteArticle = async (req, res) => {
  try {
    const { articleId } = req.params;
    const userId = req.user.id;

    // Find the article
    const article = await Article.findById(articleId);

    if (!article) {
      return res.status(404).json({
        message: 'Article not found'
      });
    }

    // Check if user is the author
    if (article.author.toString() !== userId) {
      return res.status(403).json({
        message: 'You can only delete your own articles'
      });
    }

    // Soft delete by marking as inactive
    article.isActive = false;
    await article.save();

    res.status(200).json({
      message: 'Article deleted successfully'
    });

  } catch (error) {
    console.error('Delete article error:', error);
    res.status(500).json({
      message: 'Error deleting article',
      error: error.message
    });
  }
};

// Like/Unlike article (Authenticated users)
exports.toggleLike = async (req, res) => {
  try {
    const { articleId } = req.params;
    const userId = req.user.id;

    const article = await Article.findOne({
      _id: articleId,
      status: 'published',
      isActive: true
    });

    if (!article) {
      return res.status(404).json({
        message: 'Article not found'
      });
    }

    const existingLike = article.likes.find(like => like.user.toString() === userId);

    if (existingLike) {
      // Remove like
      await article.removeLike(userId);
      res.status(200).json({
        message: 'Article unliked',
        liked: false,
        likeCount: article.likes.length
      });
    } else {
      // Add like
      await article.addLike(userId);
      res.status(200).json({
        message: 'Article liked',
        liked: true,
        likeCount: article.likes.length
      });
    }

  } catch (error) {
    console.error('Toggle like error:', error);
    res.status(500).json({
      message: 'Error toggling like',
      error: error.message
    });
  }
};



// Get article categories
exports.getCategories = async (_, res) => {
  try {
    const categories = [
      'Pet Care',
      'Training Tips',
      'Health & Wellness',
      'Nutrition',
      'Grooming',
      'Behavior',
      'Safety',
      'Product Reviews',
      'Seasonal Care',
      'Emergency Care',
      'General'
    ];

    res.status(200).json({
      message: 'Categories fetched successfully',
      categories
    });

  } catch (error) {
    console.error('Get categories error:', error);
    res.status(500).json({
      message: 'Error fetching categories',
      error: error.message
    });
  }
};

// Get trending articles (most viewed/liked in last 30 days)
exports.getTrendingArticles = async (req, res) => {
  try {
    const { limit = 5 } = req.query;

    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const articles = await Article.find({
      status: 'published',
      isActive: true,
      publishedAt: { $gte: thirtyDaysAgo }
    })
    .populate('author', 'name shopImage')
    .sort({ views: -1, likeCount: -1 })
    .limit(parseInt(limit))
    .select('title excerpt featuredImage views likes publishedAt author category');

    res.status(200).json({
      message: 'Trending articles fetched successfully',
      articles
    });

  } catch (error) {
    console.error('Get trending articles error:', error);
    res.status(500).json({
      message: 'Error fetching trending articles',
      error: error.message
    });
  }
};
