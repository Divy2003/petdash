const express = require('express');
const router = express.Router();
const {
  createAppointment,
  getCustomerAppointments,
  getBusinessAppointments,
  getAppointmentDetails,
  updateAppointmentStatus
} = require('../controllers/appointmentController');
const auth = require('../middlewares/auth');

// Create new appointment (Pet Owner only)
router.post('/create', auth, createAppointment);

// Get appointments for customer (Pet Owner)
router.get('/customer', auth, getCustomerAppointments);

// Get appointments for business (Business Owner)
router.get('/business', auth, getBusinessAppointments);

// Get single appointment details
router.get('/:appointmentId', auth, getAppointmentDetails);

// Update appointment status
router.put('/:appointmentId/status', auth, updateAppointmentStatus);

module.exports = router;
