const express = require('express');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const petRoutes = require('./routes/petRoutes');
const serviceRoutes = require('./routes/serviceRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const businessRoutes = require('./routes/businessRoutes');
dotenv.config();

const app = express();

// 🔌 connect to MongoDB
const connectDB = require('./config/db');
connectDB();

app.use(express.json());
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/pet', petRoutes);
app.use('/api/service', serviceRoutes);
app.use('/api/category', categoryRoutes);
app.use('/api/business', businessRoutes);


app.listen(process.env.PORT || 5000, () => {
      console.log('Server running');
    });
