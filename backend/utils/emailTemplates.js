// Email template utilities for appointment notifications

const generateCustomerConfirmationEmail = (appointment, customer, business, service, pet) => {
  const appointmentDate = new Date(appointment.appointmentDate).toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Appointment Confirmation</title>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #2196F3, #1976D2); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; }
        .footer { background: #f5f5f5; padding: 20px; text-align: center; border-radius: 0 0 8px 8px; }
        .info-box { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #2196F3; }
        .business-info { background: #e3f2fd; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .highlight { color: #2196F3; font-weight: bold; }
        .booking-id { font-size: 18px; font-weight: bold; color: #1976D2; }
        .total-amount { font-size: 20px; font-weight: bold; color: #4CAF50; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🐾 Pet Patch USA</h1>
          <h2>Appointment Confirmed!</h2>
        </div>
        
        <div class="content">
          <p>Dear <strong>${customer.name}</strong>,</p>
          <p>Great news! Your appointment has been successfully booked. We're excited to take care of <strong>${pet.name}</strong>!</p>
          
          <div class="info-box">
            <h3>📋 Booking Details</h3>
            <p><strong>Booking ID:</strong> <span class="booking-id">${appointment.bookingId}</span></p>
            <p><strong>Service:</strong> ${service.title}</p>
            <p><strong>Pet:</strong> ${pet.name} (${pet.species}${pet.breed ? `, ${pet.breed}` : ''})</p>
            <p><strong>Date:</strong> ${appointmentDate}</p>
            <p><strong>Time:</strong> ${appointment.appointmentTime}</p>
            <p><strong>Total Amount:</strong> <span class="total-amount">$${appointment.total}</span></p>
          </div>
          
          <div class="business-info">
            <h3>🏪 Service Provider Details</h3>
            <p><strong>Business:</strong> ${business.name}</p>
            <p><strong>Phone:</strong> ${business.phoneNumber}</p>
            <p><strong>Address:</strong> ${business.streetName}, ${business.city}, ${business.state} ${business.zipCode}</p>
          </div>
          
          ${appointment.addOnServices && appointment.addOnServices.length > 0 ? `
            <div class="info-box">
              <h3>➕ Add-on Services</h3>
              ${appointment.addOnServices.map(addon => `<p>• ${addon.name} - $${addon.price}</p>`).join('')}
            </div>
          ` : ''}
          
          ${appointment.notes ? `
            <div class="info-box">
              <h3>📝 Your Notes</h3>
              <p>${appointment.notes}</p>
            </div>
          ` : ''}
          
          <p><strong>What to bring:</strong></p>
          <ul>
            <li>Your pet's vaccination records</li>
            <li>Any medications your pet is currently taking</li>
            <li>Your pet's favorite toy or blanket for comfort</li>
          </ul>
          
          <p>If you need to reschedule or have any questions, please contact the service provider directly.</p>
        </div>
        
        <div class="footer">
          <p>Thank you for choosing Pet Patch USA! 🐾</p>
          <p><small>This is an automated message. Please do not reply to this email.</small></p>
        </div>
      </div>
    </body>
    </html>
  `;
};

const generateBusinessNotificationEmail = (appointment, customer, business, service, pet) => {
  const appointmentDate = new Date(appointment.appointmentDate).toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>New Appointment Booking</title>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #4CAF50, #388E3C); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; }
        .footer { background: #f5f5f5; padding: 20px; text-align: center; border-radius: 0 0 8px 8px; }
        .info-box { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #4CAF50; }
        .customer-info { background: #e8f5e8; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .pet-info { background: #fff3e0; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .highlight { color: #4CAF50; font-weight: bold; }
        .booking-id { font-size: 18px; font-weight: bold; color: #388E3C; }
        .total-amount { font-size: 20px; font-weight: bold; color: #4CAF50; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🐾 Pet Patch USA</h1>
          <h2>New Appointment Booking</h2>
        </div>
        
        <div class="content">
          <p>Dear <strong>${business.name}</strong>,</p>
          <p>You have received a new appointment booking! Please prepare for the upcoming service.</p>
          
          <div class="info-box">
            <h3>📋 Booking Details</h3>
            <p><strong>Booking ID:</strong> <span class="booking-id">${appointment.bookingId}</span></p>
            <p><strong>Service:</strong> ${service.title}</p>
            <p><strong>Date:</strong> ${appointmentDate}</p>
            <p><strong>Time:</strong> ${appointment.appointmentTime}</p>
            <p><strong>Total Amount:</strong> <span class="total-amount">$${appointment.total}</span></p>
          </div>
          
          <div class="customer-info">
            <h3>👤 Customer Details</h3>
            <p><strong>Name:</strong> ${customer.name}</p>
            <p><strong>Phone:</strong> ${customer.phoneNumber}</p>
            <p><strong>Email:</strong> ${customer.email}</p>
            <p><strong>Address:</strong> ${customer.streetName}, ${customer.city}, ${customer.state} ${customer.zipCode}</p>
          </div>
          
          <div class="pet-info">
            <h3>🐕 Pet Details</h3>
            <p><strong>Pet Name:</strong> ${pet.name}</p>
            <p><strong>Species:</strong> ${pet.species}</p>
            ${pet.breed ? `<p><strong>Breed:</strong> ${pet.breed}</p>` : ''}
            ${pet.weight ? `<p><strong>Size:</strong> ${pet.weight}</p>` : ''}
            ${pet.gender ? `<p><strong>Gender:</strong> ${pet.gender}</p>` : ''}
            ${pet.birthday ? `<p><strong>Age:</strong> ${Math.floor((new Date() - new Date(pet.birthday)) / (365.25 * 24 * 60 * 60 * 1000))} years old</p>` : ''}
          </div>
          
          ${appointment.addOnServices && appointment.addOnServices.length > 0 ? `
            <div class="info-box">
              <h3>➕ Add-on Services</h3>
              ${appointment.addOnServices.map(addon => `<p>• ${addon.name} - $${addon.price}</p>`).join('')}
            </div>
          ` : ''}
          
          ${appointment.notes ? `
            <div class="info-box">
              <h3>📝 Customer Notes</h3>
              <p><em>"${appointment.notes}"</em></p>
            </div>
          ` : ''}
          
          <p><strong>Preparation checklist:</strong></p>
          <ul>
            <li>Review the service requirements</li>
            <li>Prepare necessary equipment and supplies</li>
            <li>Check for any special instructions in customer notes</li>
            <li>Confirm appointment time with customer if needed</li>
          </ul>
        </div>
        
        <div class="footer">
          <p>Pet Patch USA Business Portal 🐾</p>
          <p><small>This is an automated notification. Please contact the customer directly for any changes.</small></p>
        </div>
      </div>
    </body>
    </html>
  `;
};

module.exports = {
  generateCustomerConfirmationEmail,
  generateBusinessNotificationEmail
};
