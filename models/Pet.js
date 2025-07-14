const mongoose = require('mongoose');

const petSchema = new mongoose.Schema({
  owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  species: String,
  typeOfPet: String,
  breed: String,
  weight: String,
  gender: { type: String, enum: ['Male', 'Female'] },
  birthday: Date,
  allergies: [String],
  currentMedications: String,
  lastVaccinatedDate: Date,
  vaccinations: [{ name: String, date: Date }],
  favoriteToys: [String],
  profileImage: { type: String, default: null },
  // Additional Info
  neutered: Boolean,
  vaccinated: Boolean,
  friendlyWithDogs: Boolean,
  friendlyWithCats: Boolean,
  friendlyWithKidsUnder10: Boolean,
  friendlyWithKidsOver10: Boolean,
  microchipped: Boolean,
  purebred: Boolean,
  pottyTrained: Boolean,
  // Primary Services
  preferredVeterinarian: String,
  preferredPharmacy: String,
  preferredGroomer: String,
  favoriteDogPark: String
});

module.exports = mongoose.model('Pet', petSchema); 