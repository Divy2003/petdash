// Test file for Appointment API
// This file demonstrates how to use the appointment endpoints

const axios = require('axios');

const BASE_URL = 'http://localhost:5000/api';

// Example usage of appointment endpoints
const testAppointmentAPI = async () => {
  try {
    // 1. First, you need to login to get a JWT token
    console.log('1. Login as Pet Owner...');
    const loginResponse = await axios.post(`${BASE_URL}/auth/login`, {
      email: 'petowner@example.com',
      password: 'password123'
    });
    
    const customerToken = loginResponse.data.token;
    console.log('✅ Pet Owner logged in successfully');

    // 2. Create an appointment
    console.log('\n2. Creating appointment...');
    const appointmentData = {
      businessId: '64a1b2c3d4e5f6789012345a', // Replace with actual business ID
      serviceId: '64a1b2c3d4e5f6789012345b',  // Replace with actual service ID
      petId: '64a1b2c3d4e5f6789012345c',      // Replace with actual pet ID
      appointmentDate: '2024-05-20',
      appointmentTime: '11:00 AM',
      addOnServices: [
        {
          name: 'Nail Trimming',
          price: 15
        }
      ],
      subtotal: 80,
      tax: 20,
      total: 100,
      notes: 'Pet is nervous around strangers',
      couponCode: 'SAVE10'
    };

    const createResponse = await axios.post(`${BASE_URL}/appointment/create`, appointmentData, {
      headers: {
        'Authorization': `Bearer ${customerToken}`,
        'Content-Type': 'application/json'
      }
    });

    console.log('✅ Appointment created:', createResponse.data.appointment.bookingId);
    const appointmentId = createResponse.data.appointment._id;

    // 3. Get customer appointments
    console.log('\n3. Getting customer appointments...');
    const customerAppointments = await axios.get(`${BASE_URL}/appointment/customer`, {
      headers: {
        'Authorization': `Bearer ${customerToken}`
      }
    });

    console.log('✅ Customer appointments retrieved:', customerAppointments.data.appointments.length);

    // 4. Get appointment details
    console.log('\n4. Getting appointment details...');
    const appointmentDetails = await axios.get(`${BASE_URL}/appointment/${appointmentId}`, {
      headers: {
        'Authorization': `Bearer ${customerToken}`
      }
    });

    console.log('✅ Appointment details retrieved:', appointmentDetails.data.appointment.bookingId);

    // 5. Login as Business Owner
    console.log('\n5. Login as Business Owner...');
    const businessLoginResponse = await axios.post(`${BASE_URL}/auth/login`, {
      email: 'business@example.com',
      password: 'password123'
    });
    
    const businessToken = businessLoginResponse.data.token;
    console.log('✅ Business Owner logged in successfully');

    // 6. Get business appointments
    console.log('\n6. Getting business appointments...');
    const businessAppointments = await axios.get(`${BASE_URL}/appointment/business`, {
      headers: {
        'Authorization': `Bearer ${businessToken}`
      }
    });

    console.log('✅ Business appointments retrieved:', businessAppointments.data.appointments.length);

    // 7. Update appointment status
    console.log('\n7. Updating appointment status...');
    const statusUpdate = await axios.put(`${BASE_URL}/appointment/${appointmentId}/status`, {
      status: 'completed'
    }, {
      headers: {
        'Authorization': `Bearer ${businessToken}`,
        'Content-Type': 'application/json'
      }
    });

    console.log('✅ Appointment status updated:', statusUpdate.data.appointment.status);

  } catch (error) {
    console.error('❌ Error:', error.response?.data || error.message);
  }
};

// Uncomment the line below to run the test
// testAppointmentAPI();

console.log(`
🚀 Appointment API Test File

To test the appointment API:
1. Make sure your server is running (npm run dev)
2. Create some test users (pet owner and business)
3. Create test pets and services
4. Update the IDs in this file with actual IDs from your database
5. Uncomment the testAppointmentAPI() call at the bottom
6. Run: node test-appointment.js

📧 Email Configuration:
Make sure your .env file has:
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

For Gmail, you need to:
1. Enable 2-factor authentication
2. Generate an app password
3. Use the app password in EMAIL_PASS

📋 Available Endpoints:
- POST /api/appointment/create
- GET /api/appointment/customer
- GET /api/appointment/business
- GET /api/appointment/:appointmentId
- PUT /api/appointment/:appointmentId/status
`);
