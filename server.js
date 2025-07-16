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
const cors = require('cors');
dotenv.config();

const app = express();

// 🔌 connect to MongoDB
const connectDB = require('./config/db');
connectDB();

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


app.listen(process.env.PORT || 5000, () => {
      console.log('Server running');
    });
