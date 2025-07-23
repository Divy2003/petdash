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
const { requirePetOwnerAccess, requireBusinessAccess, updateUserContext } = require('../middlewares/roleAuth');

// Create new appointment (Pet Owner access required)
router.post('/create', auth, requirePetOwnerAccess, createAppointment);

// Get appointments for customer (Pet Owner access required)
router.get('/customer', auth, requirePetOwnerAccess, getCustomerAppointments);

// Get appointments for business (Business access required)
router.get('/business', auth, requireBusinessAccess, getBusinessAppointments);

// Get single appointment details (accessible to both roles)
router.get('/:appointmentId', auth, updateUserContext, getAppointmentDetails);

// Update appointment status (accessible to both roles)
router.put('/:appointmentId/status', auth, updateUserContext, updateAppointmentStatus);

module.exports = router;
