const express = require('express');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes'); 
const profileRoutes = require('./routes/profileRoutes');
const petRoutes = require('./routes/petRoutes');
const serviceRoutes = require('./routes/serviceRoutes');
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


app.listen(process.env.PORT || 5000, () => {
      console.log('Server running');
    });
