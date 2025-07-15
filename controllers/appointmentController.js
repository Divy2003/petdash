const Appointment = require('../models/Appointment');
const User = require('../models/User');
const Service = require('../models/Service');
const Pet = require('../models/Pet');
const nodemailer = require('nodemailer');
const { generateCustomerConfirmationEmail, generateBusinessNotificationEmail } = require('../utils/emailTemplates');

// Email configuration
const createEmailTransporter = () => {
  return nodemailer.createTransport({
    service: 'gmail', // You can change this to your preferred email service
    auth: {
      user: process.env.EMAIL_USER, // Add this to your .env file
      pass: process.env.EMAIL_PASS  // Add this to your .env file
    }
  });
};

// Send appointment confirmation email
const sendAppointmentEmail = async (appointment, customer, business, service, pet) => {
  try {
    const transporter = createEmailTransporter();

    // Generate email content using templates
    const customerEmailHtml = generateCustomerConfirmationEmail(appointment, customer, business, service, pet);
    const businessEmailHtml = generateBusinessNotificationEmail(appointment, customer, business, service, pet);

    // Email to customer
    const customerMailOptions = {
      from: process.env.EMAIL_USER,
      to: customer.email,
      subject: 'Appointment Confirmation - Pet Patch USA',
      html: customerEmailHtml
    };

    // Email to business
    const businessMailOptions = {
      from: process.env.EMAIL_USER,
      to: business.email,
      subject: 'New Appointment Booking - Pet Patch USA',
      html: businessEmailHtml
    };

    await transporter.sendMail(customerMailOptions);
    await transporter.sendMail(businessMailOptions);

    return true;
  } catch (error) {
    console.error('Email sending failed:', error);
    return false;
  }
};

// Create new appointment
exports.createAppointment = async (req, res) => {
  try {
    const {
      businessId,
      serviceId,
      petId,
      appointmentDate,
      appointmentTime,
      addOnServices = [],
      subtotal,
      tax,
      total,
      notes,
      couponCode
    } = req.body;

    const customerId = req.user.id;

    // Validate required fields
    if (!businessId || !serviceId || !petId || !appointmentDate || !appointmentTime || !subtotal || !tax || !total) {
      return res.status(400).json({ message: 'All required fields must be provided' });
    }

    // Verify that the pet belongs to the customer
    const pet = await Pet.findOne({ _id: petId, owner: customerId });
    if (!pet) {
      return res.status(404).json({ message: 'Pet not found or does not belong to you' });
    }

    // Verify service exists and belongs to the business
    const service = await Service.findOne({ _id: serviceId, business: businessId });
    if (!service) {
      return res.status(404).json({ message: 'Service not found' });
    }

    // Verify business exists
    const business = await User.findOne({ _id: businessId, userType: 'Business' });
    if (!business) {
      return res.status(404).json({ message: 'Business not found' });
    }

    // Create appointment
    const appointment = new Appointment({
      customer: customerId,
      business: businessId,
      service: serviceId,
      pet: petId,
      appointmentDate,
      appointmentTime,
      addOnServices,
      subtotal,
      tax,
      total,
      notes,
      couponCode
    });

    await appointment.save();

    // Populate appointment data for email
    await appointment.populate([
      { path: 'customer', select: 'name email phoneNumber streetName city state zipCode' },
      { path: 'business', select: 'name email phoneNumber streetName city state zipCode' },
      { path: 'service', select: 'title description price' },
      { path: 'pet', select: 'name species breed weight' }
    ]);

    // Send confirmation emails
    const emailSent = await sendAppointmentEmail(
      appointment,
      appointment.customer,
      appointment.business,
      appointment.service,
      appointment.pet
    );

    // Update email status
    appointment.emailSent = emailSent;
    await appointment.save();

    res.status(201).json({
      message: 'Appointment created successfully',
      appointment,
      emailSent
    });

  } catch (error) {
    console.error('Create appointment error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get appointments for customer
exports.getCustomerAppointments = async (req, res) => {
  try {
    const customerId = req.user.id;
    
    const appointments = await Appointment.find({ customer: customerId })
      .populate('business', 'name phoneNumber streetName city state zipCode')
      .populate('service', 'title description price')
      .populate('pet', 'name species breed')
      .sort({ appointmentDate: -1 });

    res.json({ appointments });
  } catch (error) {
    console.error('Get customer appointments error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get appointments for business
exports.getBusinessAppointments = async (req, res) => {
  try {
    const businessId = req.user.id;
    
    const appointments = await Appointment.find({ business: businessId })
      .populate('customer', 'name email phoneNumber')
      .populate('service', 'title description price')
      .populate('pet', 'name species breed weight')
      .sort({ appointmentDate: -1 });

    res.json({ appointments });
  } catch (error) {
    console.error('Get business appointments error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get single appointment details
exports.getAppointmentDetails = async (req, res) => {
  try {
    const { appointmentId } = req.params;
    const userId = req.user.id;

    const appointment = await Appointment.findById(appointmentId)
      .populate('customer', 'name email phoneNumber streetName city state zipCode')
      .populate('business', 'name email phoneNumber streetName city state zipCode')
      .populate('service', 'title description price')
      .populate('pet', 'name species breed weight');

    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    // Check if user is authorized to view this appointment
    if (appointment.customer._id.toString() !== userId && appointment.business._id.toString() !== userId) {
      return res.status(403).json({ message: 'Not authorized to view this appointment' });
    }

    res.json({ appointment });
  } catch (error) {
    console.error('Get appointment details error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Update appointment status
exports.updateAppointmentStatus = async (req, res) => {
  try {
    const { appointmentId } = req.params;
    const { status } = req.body;
    const userId = req.user.id;

    if (!['upcoming', 'completed', 'cancelled'].includes(status)) {
      return res.status(400).json({ message: 'Invalid status' });
    }

    const appointment = await Appointment.findById(appointmentId);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    // Check if user is authorized to update this appointment
    if (appointment.customer.toString() !== userId && appointment.business.toString() !== userId) {
      return res.status(403).json({ message: 'Not authorized to update this appointment' });
    }

    appointment.status = status;
    await appointment.save();

    res.json({ message: 'Appointment status updated successfully', appointment });
  } catch (error) {
    console.error('Update appointment status error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
