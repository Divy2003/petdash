const Adoption = require('../models/Adoption');
const User = require('../models/User');

const sampleAdoptions = [
  {
    name: 'Pearl',
    species: 'Dog',
    breed: 'Golden Retriever Mix',
    age: '1 year',
    ageCategory: 'Young',
    gender: 'Female',
    size: 'Large',
    weight: '55 lbs',
    color: 'Golden',
    images: ['/uploads/pearl-1.jpg', '/uploads/pearl-2.jpg'],
    primaryImage: '/uploads/pearl-1.jpg',
    vaccinated: true,
    neutered: true,
    microchipped: true,
    healthStatus: 'Healthy',
    personality: ['Friendly', 'Playful', 'Gentle', 'Good with kids'],
    goodWithKids: true,
    goodWithDogs: true,
    goodWithCats: false,
    energyLevel: 'Medium',
    description: 'Pearl is a sweet and gentle Golden Retriever mix who loves to play and cuddle. She\'s great with children and other dogs, making her the perfect family companion.',
    story: 'Pearl was found as a stray puppy and has been in foster care for 6 months. She\'s now ready for her forever home!',
    location: {
      address: '2464 Royal Ln',
      city: 'Mesa',
      state: 'New Jersey',
      zipCode: '45463',
      coordinates: {
        latitude: 40.7128,
        longitude: -74.0060
      }
    },
    shelter: {
      name: 'North Shore Animal League America',
      phone: '516-883-7575',
      email: 'adopt@nsalamerica.org',
      website: 'www.nsalamerica.org',
      hours: 'Open daily from 10am-5:30pm for kitten and cat adoptions',
      adoptionProcess: 'Fill out application, meet and greet, home visit if required'
    },
    adoptionFee: 250,
    adoptionStatus: 'Available',
    adoptionRequirements: ['Adults-only home', 'Needs yard', 'First-time owner OK'],
    isActive: true,
    featured: true
  },
  {
    name: 'Chianti',
    species: 'Cat',
    breed: 'Domestic Shorthair',
    age: '2 years',
    ageCategory: 'Adult',
    gender: 'Female',
    size: 'Medium',
    weight: '8 lbs',
    color: 'Orange Tabby',
    images: ['/uploads/chianti-1.jpg'],
    primaryImage: '/uploads/chianti-1.jpg',
    vaccinated: true,
    neutered: true,
    microchipped: true,
    healthStatus: 'Healthy',
    specialNeeds: 'Hurricane Laura survivor - needs patient home',
    personality: ['Shy', 'Sweet', 'Quiet', 'Needs time to warm up'],
    goodWithKids: false,
    goodWithDogs: false,
    goodWithCats: true,
    energyLevel: 'Low',
    description: 'Hurricane Laura survivor Chianti isn\'t quite as smooth as the wine his name implies. This sometimes-awkward friend is going to need a very predictable home setting and young children to help him slowly acclimate to a new lifestyle as a pampered house cat.',
    story: 'Chianti survived Hurricane Laura and has been working on building trust with humans. He needs a quiet, patient home to help him feel secure.',
    location: {
      address: '25 Davis Avenue',
      city: 'Port Washington',
      state: 'NY',
      zipCode: '11050',
      coordinates: {
        latitude: 40.8259,
        longitude: -73.6982
      }
    },
    shelter: {
      name: 'Bianca\'s Furry Friends Feline',
      phone: '516-883-7575',
      email: 'info@biancasfurryfriends.org',
      website: 'www.biancasfurryfriends.org',
      hours: 'Open Monday-Thursday from 10am-5:30pm for puppy and dog adoptions, and Friday-Sunday by appointment only',
      adoptionProcess: 'Social distancing protocols will be observed while on campus and face masks must be worn at all times'
    },
    adoptionFee: 150,
    adoptionStatus: 'Available',
    adoptionRequirements: ['Quiet home', 'No young children', 'Experience with shy cats preferred'],
    isActive: true,
    featured: false
  },
  {
    name: 'Lilo',
    species: 'Dog',
    breed: 'Mixed Breed',
    age: '3 years',
    ageCategory: 'Adult',
    gender: 'Male',
    size: 'Medium',
    weight: '45 lbs',
    color: 'Black and Tan',
    images: ['/uploads/lilo-1.jpg'],
    primaryImage: '/uploads/lilo-1.jpg',
    vaccinated: true,
    neutered: true,
    microchipped: true,
    healthStatus: 'Healthy',
    personality: ['Loyal', 'Protective', 'Calm', 'Senior-friendly'],
    goodWithKids: true,
    goodWithDogs: true,
    goodWithCats: false,
    energyLevel: 'Low',
    description: 'Lilo is a calm and loyal companion who would make a great addition to any family. He\'s especially good with seniors and enjoys quiet walks and relaxing at home.',
    story: 'Lilo was surrendered by his previous family due to housing restrictions. He\'s looking for a new family to love and protect.',
    location: {
      address: '2464 Royal Ln',
      city: 'Mesa',
      state: 'New Jersey',
      zipCode: '45463',
      coordinates: {
        latitude: 40.7128,
        longitude: -74.0060
      }
    },
    shelter: {
      name: 'North Shore Animal League America',
      phone: '516-883-7575',
      email: 'adopt@nsalamerica.org',
      website: 'www.nsalamerica.org',
      hours: 'Open daily from 10am-5:30pm',
      adoptionProcess: 'Fill out application, meet and greet, home visit if required'
    },
    adoptionFee: 200,
    adoptionStatus: 'Available',
    adoptionRequirements: ['Experienced dog owner preferred', 'Secure yard'],
    isActive: true,
    featured: false
  }
];

const seedAdoptions = async () => {
  try {
    // Clear existing adoptions
    await Adoption.deleteMany({});
    console.log('🗑️ Cleared existing adoptions');

    // Find a business user to assign as poster
    const businessUser = await User.findOne({ userType: 'Business' });
    
    if (!businessUser) {
      console.log('⚠️ No business user found. Creating sample business user...');
      
      const sampleBusiness = new User({
        name: 'North Shore Animal League',
        email: 'shelter@nsalamerica.org',
        password: 'hashedpassword123', // In real app, this would be properly hashed
        userType: 'Business',
        phoneNumber: '516-883-7575',
        streetName: '25 Davis Avenue',
        zipCode: '11050',
        city: 'Port Washington',
        state: 'NY'
      });
      
      await sampleBusiness.save();
      console.log('✅ Created sample business user');
      
      // Assign the business user to all adoptions
      sampleAdoptions.forEach(adoption => {
        adoption.postedBy = sampleBusiness._id;
      });
    } else {
      // Assign existing business user to all adoptions
      sampleAdoptions.forEach(adoption => {
        adoption.postedBy = businessUser._id;
      });
    }

    // Insert sample adoptions
    await Adoption.insertMany(sampleAdoptions);
    console.log('✅ Sample adoptions seeded successfully');
    
    return true;
  } catch (error) {
    console.error('❌ Error seeding adoptions:', error);
    return false;
  }
};

module.exports = { seedAdoptions };
