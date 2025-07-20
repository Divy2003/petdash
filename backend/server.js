const express = require('express');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const petRoutes = require('./routes/petRoutes');
const serviceRoutes = require('./routes/serviceRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const businessRoutes = require('./routes/businessRoutes');
const appointmentRoutes = require('./routes/appointmentRoutes');
const productRoutes = require('./routes/productRoutes');
const orderRoutes = require('./routes/orderRoutes');
const subscriptionRoutes = require('./routes/subscriptionRoutes');
const reviewRoutes = require('./routes/reviewRoutes');
const articleRoutes = require('./routes/articleRoutes');
const adoptionRoutes = require('./routes/adoptionRoutes');
const cors = require('cors');
dotenv.config();

const app = express();

// 🔌 connect to MongoDB
const connectDB = require('./config/db');
const { runSeeder } = require('./seeders/databaseSeeder');

// Connect to database and run seeder
const initializeDatabase = async () => {
  try {
    await connectDB();
    console.log('📦 Database connected successfully');

    // Run seeder after database connection
    await runSeeder();
  } catch (error) {
    console.error('❌ Database initialization failed:', error);
    process.exit(1);
  }
};

initializeDatabase();

app.use(express.json());
app.use(cors());
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/pet', petRoutes);
app.use('/api/service', serviceRoutes);
app.use('/api/category', categoryRoutes);
app.use('/api/business', businessRoutes);
app.use('/api/appointment', appointmentRoutes);
app.use('/api/product', productRoutes);
app.use('/api/order', orderRoutes);
app.use('/api/subscription', subscriptionRoutes);
app.use('/api/review', reviewRoutes);
app.use('/api/article', articleRoutes);
app.use('/api/adoption', adoptionRoutes);


app.listen(process.env.PORT || 5000, () => {
      console.log('Server running');
    });
