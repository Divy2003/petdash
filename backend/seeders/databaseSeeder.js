const bcrypt = require('bcryptjs');
const User = require('../models/User');
const Category = require('../models/Category');
const Pet = require('../models/Pet');
const Service = require('../models/Service');
const Product = require('../models/Product');
const Article = require('../models/Article');
const Review = require('../models/Review');
const Appointment = require('../models/Appointment');
const Order = require('../models/Order');
const { seedAdoptions } = require('./adoptionSeeder');

// Sample data
const sampleUsers = [
  {
    name: 'System Administrator',
    email: 'admin@petdash.com',
    password: 'admin123',
    userType: 'Business',
    phoneNumber: '+1234567888',
    profileImage: 'uploads/admin.jpg',
    shopImage: 'uploads/admin-shop.jpg',
    shopOpenTime: '00:00',
    shopCloseTime: '23:59',
    addresses: [
      {
        label: 'Primary',
        streetName: '1 Admin Plaza',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        isPrimary: true,
        isActive: true
      }
    ]
  },
  {
    name: 'John Doe',
    email: 'petowner1@example.com',
    password: 'password123',
    userType: 'Pet Owner',
    phoneNumber: '+1234567890',
    profileImage: 'uploads/profile1.jpg',
    addresses: [
      {
        label: 'Home',
        streetName: '123 Main St',
        city: 'New York',
        state: 'NY',
        zipCode: '12345',
        country: 'USA',
        isPrimary: true,
        isActive: true
      },
      {
        label: 'Work',
        streetName: '789 Business Ave',
        city: 'New York',
        state: 'NY',
        zipCode: '12347',
        country: 'USA',
        isPrimary: false,
        isActive: true
      }
    ]
  },
  {
    name: 'Jane Smith',
    email: 'petowner2@example.com',
    password: 'password123',
    userType: 'Pet Owner',
    phoneNumber: '+1234567891',
    profileImage: 'uploads/profile2.jpg',
    addresses: [
      {
        label: 'Home',
        streetName: '456 Oak Ave',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '12346',
        country: 'USA',
        isPrimary: true,
        isActive: true
      }
    ]
  },
  {
    name: 'Pet Care Plus',
    email: 'business1@example.com',
    password: 'password123',
    userType: 'Business',
    phoneNumber: '+1234567892',
    shopImage: 'uploads/shop1.jpg',
    shopOpenTime: '08:00',
    shopCloseTime: '18:00',
    addresses: [
      {
        label: 'Shop',
        streetName: '789 Business Blvd',
        city: 'Chicago',
        state: 'IL',
        zipCode: '12347',
        country: 'USA',
        isPrimary: true,
        isActive: true
      }
    ]
  },
  {
    name: 'Happy Paws Grooming',
    email: 'business2@example.com',
    password: 'password123',
    userType: 'Business',
    phoneNumber: '+1234567893',
    shopImage: 'uploads/shop2.jpg',
    shopOpenTime: '09:00',
    shopCloseTime: '17:00',
    addresses: [
      {
        label: 'Main Shop',
        streetName: '321 Pet Lane',
        city: 'Miami',
        state: 'FL',
        zipCode: '12348',
        country: 'USA',
        isPrimary: true,
        isActive: true
      },
      {
        label: 'Branch Location',
        streetName: '555 Beach Blvd',
        city: 'Miami',
        state: 'FL',
        zipCode: '12350',
        country: 'USA',
        isPrimary: false,
        isActive: true
      }
    ]
  },
  {
    name: 'Veterinary Clinic Pro',
    email: 'business3@example.com',
    password: 'password123',
    userType: 'Business',
    phoneNumber: '+1234567894',
    shopImage: 'uploads/shop3.jpg',
    shopOpenTime: '07:00',
    shopCloseTime: '19:00',
    addresses: [
      {
        label: 'Clinic',
        streetName: '654 Health St',
        city: 'Seattle',
        state: 'WA',
        zipCode: '12349',
        country: 'USA',
        isPrimary: true,
        isActive: true
      }
    ]
  }
];

const sampleCategories = [
  {
    name: 'Veterinary Care',
    description: 'Professional veterinary services for your pets',
    icon: 'medical-cross',
    color: '#dc3545',
    order: 1
  },
  {
    name: 'Pet Grooming',
    description: 'Professional grooming services to keep your pet looking great',
    icon: 'scissors',
    color: '#28a745',
    order: 2
  },
  {
    name: 'Pet Training',
    description: 'Professional training services for behavioral improvement',
    icon: 'graduation-cap',
    color: '#007bff',
    order: 3
  },
  {
    name: 'Pet Boarding',
    description: 'Safe and comfortable boarding services for your pets',
    icon: 'home',
    color: '#ffc107',
    order: 4
  },
  {
    name: 'Pet Walking',
    description: 'Professional dog walking and exercise services',
    icon: 'walking',
    color: '#17a2b8',
    order: 5
  }
];

const samplePets = [
  {
    name: 'Buddy',
    species: 'Dog',
    typeOfPet: 'Companion',
    breed: 'Golden Retriever',
    weight: '30kg',
    gender: 'Male',
    birthday: new Date('2020-05-15'),
    allergies: ['Chicken'],
    currentMedications: 'None',
    neutered: true,
    vaccinated: true,
    friendlyWithDogs: true,
    friendlyWithCats: true,
    friendlyWithKidsUnder10: true,
    friendlyWithKidsOver10: true,
    microchipped: true,
    pottyTrained: true
  },
  {
    name: 'Whiskers',
    species: 'Cat',
    typeOfPet: 'Indoor',
    breed: 'Persian',
    weight: '4kg',
    gender: 'Female',
    birthday: new Date('2019-08-22'),
    allergies: ['Dust'],
    currentMedications: 'Flea treatment',
    neutered: true,
    vaccinated: true,
    friendlyWithDogs: false,
    friendlyWithCats: true,
    friendlyWithKidsUnder10: true,
    friendlyWithKidsOver10: true,
    microchipped: true
  },
  {
    name: 'Max',
    species: 'Dog',
    typeOfPet: 'Guard',
    breed: 'German Shepherd',
    weight: '35kg',
    gender: 'Male',
    birthday: new Date('2018-12-10'),
    allergies: [],
    currentMedications: 'Joint supplements',
    neutered: true,
    vaccinated: true,
    friendlyWithDogs: true,
    friendlyWithCats: false,
    friendlyWithKidsUnder10: false,
    friendlyWithKidsOver10: true,
    microchipped: true,
    pottyTrained: true
  },
  {
    name: 'Luna',
    species: 'Cat',
    typeOfPet: 'Outdoor',
    breed: 'Maine Coon',
    weight: '6kg',
    gender: 'Female',
    birthday: new Date('2021-03-05'),
    allergies: ['Seafood'],
    currentMedications: 'None',
    neutered: true,
    vaccinated: true,
    friendlyWithDogs: true,
    friendlyWithCats: true,
    friendlyWithKidsUnder10: true,
    friendlyWithKidsOver10: true,
    microchipped: true
  },
  {
    name: 'Charlie',
    species: 'Dog',
    typeOfPet: 'Companion',
    breed: 'Labrador',
    weight: '28kg',
    gender: 'Male',
    birthday: new Date('2020-11-18'),
    allergies: ['Beef'],
    currentMedications: 'Heartworm prevention',
    neutered: true,
    vaccinated: true,
    friendlyWithDogs: true,
    friendlyWithCats: true,
    friendlyWithKidsUnder10: true,
    friendlyWithKidsOver10: true,
    microchipped: true,
    pottyTrained: true
  }
];

// Hash password function
const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10);
  return await bcrypt.hash(password, salt);
};

// Seeder functions
const seedUsers = async () => {
  try {
    const existingUsers = await User.countDocuments();
    if (existingUsers > 0) {
      console.log('Users already exist, skipping user seeding...');
      return await User.find();
    }

    console.log('Seeding users...');
    const hashedUsers = await Promise.all(
      sampleUsers.map(async (user) => ({
        ...user,
        password: await hashPassword(user.password)
      }))
    );

    const users = await User.insertMany(hashedUsers);
    console.log(`✅ ${users.length} users seeded successfully`);
    return users;
  } catch (error) {
    console.error('Error seeding users:', error);
    throw error;
  }
};

const seedCategories = async () => {
  try {
    const existingCategories = await Category.countDocuments();
    if (existingCategories > 0) {
      console.log('Categories already exist, skipping category seeding...');
      return await Category.find();
    }

    console.log('Seeding categories...');
    const categories = await Category.insertMany(sampleCategories);
    console.log(`✅ ${categories.length} categories seeded successfully`);
    return categories;
  } catch (error) {
    console.error('Error seeding categories:', error);
    throw error;
  }
};

const seedPets = async (users) => {
  try {
    const existingPets = await Pet.countDocuments();
    if (existingPets > 0) {
      console.log('Pets already exist, skipping pet seeding...');
      return await Pet.find();
    }

    console.log('Seeding pets...');
    const petOwners = users.filter(user => user.userType === 'Pet Owner');

    const petsWithOwners = samplePets.map((pet, index) => ({
      ...pet,
      owner: petOwners[index % petOwners.length]._id
    }));

    const pets = await Pet.insertMany(petsWithOwners);
    console.log(`✅ ${pets.length} pets seeded successfully`);
    return pets;
  } catch (error) {
    console.error('Error seeding pets:', error);
    throw error;
  }
};

const seedServices = async (users, categories) => {
  try {
    const existingServices = await Service.countDocuments();
    if (existingServices > 0) {
      console.log('Services already exist, skipping service seeding...');
      return await Service.find();
    }

    console.log('Seeding services...');
    const businesses = users.filter(user => user.userType === 'Business');

    const sampleServices = [
      {
        title: 'Complete Health Checkup',
        description: 'Comprehensive health examination for your pet',
        serviceIncluded: 'Physical exam, vaccinations, blood work',
        notes: 'Recommended annually for adult pets',
        price: '$150',
        images: ['uploads/service1.jpg'],
        availableFor: { dogs: ['Small', 'Medium', 'Large'], cats: ['Small', 'Medium'] }
      },
      {
        title: 'Professional Grooming',
        description: 'Full grooming service including bath, cut, and nail trim',
        serviceIncluded: 'Bath, haircut, nail trimming, ear cleaning',
        notes: 'Includes blow dry and styling',
        price: '$80',
        images: ['uploads/service2.jpg'],
        availableFor: { dogs: ['Small', 'Medium', 'Large'], cats: ['Medium', 'Large'] }
      },
      {
        title: 'Basic Obedience Training',
        description: 'Fundamental training for well-behaved pets',
        serviceIncluded: 'Sit, stay, come, heel commands',
        notes: '6-week program with weekly sessions',
        price: '$200',
        images: ['uploads/service3.jpg'],
        availableFor: { dogs: ['Small', 'Medium', 'Large'] }
      },
      {
        title: 'Pet Boarding Service',
        description: 'Safe and comfortable overnight care',
        serviceIncluded: 'Feeding, exercise, medication administration',
        notes: 'Climate controlled facility with 24/7 monitoring',
        price: '$50/night',
        images: ['uploads/service4.jpg'],
        availableFor: { dogs: ['Small', 'Medium', 'Large'], cats: ['Small', 'Medium', 'Large'] }
      },
      {
        title: 'Daily Dog Walking',
        description: 'Professional dog walking service',
        serviceIncluded: '30-minute walk, fresh water, basic care',
        notes: 'Available Monday through Friday',
        price: '$25',
        images: ['uploads/service5.jpg'],
        availableFor: { dogs: ['Small', 'Medium', 'Large'] }
      }
    ];

    const servicesWithRefs = sampleServices.map((service, index) => ({
      ...service,
      business: businesses[index % businesses.length]._id,
      category: categories[index % categories.length]._id
    }));

    const services = await Service.insertMany(servicesWithRefs);
    console.log(`✅ ${services.length} services seeded successfully`);
    return services;
  } catch (error) {
    console.error('Error seeding services:', error);
    throw error;
  }
};

const seedProducts = async (users) => {
  try {
    const existingProducts = await Product.countDocuments();
    if (existingProducts > 0) {
      console.log('Products already exist, skipping product seeding...');
      return await Product.find();
    }

    console.log('Seeding products...');
    const businesses = users.filter(user => user.userType === 'Business');

    const sampleProducts = [
      {
        name: 'Premium Dog Food',
        description: 'High-quality nutrition for adult dogs',
        price: 45.99,
        images: ['uploads/product1.jpg'],
        stock: 100,
        category: 'Food',
        manufacturer: 'Pet Nutrition Co',
        shippingCost: 5.99,
        brand: 'NutriPet',
        itemWeight: '15 lbs',
        itemForm: 'Dry',
        ageRange: 'Adult',
        breedRecommendation: 'All breeds',
        dietType: 'Regular'
      },
      {
        name: 'Cat Litter Premium',
        description: 'Clumping cat litter with odor control',
        price: 24.99,
        images: ['uploads/product2.jpg'],
        stock: 75,
        category: 'Litter',
        manufacturer: 'Clean Paws Inc',
        shippingCost: 7.99,
        brand: 'CleanPaws',
        itemWeight: '20 lbs',
        itemForm: 'Granules'
      },
      {
        name: 'Interactive Dog Toy',
        description: 'Puzzle toy to keep dogs mentally stimulated',
        price: 19.99,
        images: ['uploads/product3.jpg'],
        stock: 50,
        category: 'Toys',
        manufacturer: 'PlayTime Pets',
        shippingCost: 3.99,
        brand: 'PlayTime',
        itemWeight: '1 lb',
        ageRange: 'All ages'
      },
      {
        name: 'Pet Carrier Bag',
        description: 'Comfortable and secure pet carrier for travel',
        price: 89.99,
        images: ['uploads/product4.jpg'],
        stock: 25,
        category: 'Accessories',
        manufacturer: 'Travel Pets Co',
        shippingCost: 9.99,
        brand: 'TravelSafe',
        itemWeight: '3 lbs'
      },
      {
        name: 'Vitamin Supplements',
        description: 'Daily vitamins for optimal pet health',
        price: 34.99,
        images: ['uploads/product5.jpg'],
        stock: 60,
        subscriptionAvailable: true,
        monthlyDeliveryPrice: 29.99,
        category: 'Health',
        manufacturer: 'VitaPet Labs',
        shippingCost: 4.99,
        brand: 'VitaPet',
        itemWeight: '8 oz',
        itemForm: 'Tablets'
      }
    ];

    const productsWithBusiness = sampleProducts.map((product, index) => ({
      ...product,
      business: businesses[index % businesses.length]._id
    }));

    const products = await Product.insertMany(productsWithBusiness);
    console.log(`✅ ${products.length} products seeded successfully`);
    return products;
  } catch (error) {
    console.error('Error seeding products:', error);
    throw error;
  }
};

const seedArticles = async (users, products) => {
  try {
    const existingArticles = await Article.countDocuments();
    if (existingArticles > 0) {
      console.log('Articles already exist, skipping article seeding...');
      return await Article.find();
    }

    console.log('Seeding articles...');
    const businesses = users.filter(user => user.userType === 'Business');

    const sampleArticles = [
      {
        title: 'Essential Tips for Puppy Training',
        category: 'Training Tips',
        body: 'Training a puppy requires patience, consistency, and positive reinforcement. Start with basic commands like sit, stay, and come. Always reward good behavior with treats and praise. Establish a routine for feeding, sleeping, and bathroom breaks. Socialization is crucial - expose your puppy to different people, animals, and environments in a controlled manner.',
        excerpt: 'Learn the fundamental techniques for successful puppy training',
        tags: ['training', 'puppy', 'behavior', 'tips'],
        status: 'published',
        featuredImage: 'uploads/article1.jpg',
        publishedAt: new Date()
      },
      {
        title: 'Nutrition Guide for Senior Cats',
        category: 'Health & Wellness',
        body: 'Senior cats have different nutritional needs compared to younger cats. They require easily digestible proteins, controlled phosphorus levels, and added antioxidants. Monitor their weight closely as metabolism slows down. Consider wet food to increase hydration. Regular vet checkups are essential to adjust diet based on health conditions.',
        excerpt: 'Understanding the nutritional needs of aging cats',
        tags: ['nutrition', 'senior cats', 'health', 'diet'],
        status: 'published',
        featuredImage: 'uploads/article2.jpg',
        publishedAt: new Date()
      },
      {
        title: 'Grooming Your Dog at Home',
        category: 'Grooming',
        body: 'Regular grooming keeps your dog healthy and comfortable. Brush daily to prevent matting and reduce shedding. Bathe monthly or as needed with dog-specific shampoo. Trim nails every 2-3 weeks. Clean ears weekly to prevent infections. Brush teeth regularly to maintain oral health.',
        excerpt: 'Step-by-step guide to grooming your dog at home',
        tags: ['grooming', 'dog care', 'hygiene', 'home care'],
        status: 'published',
        featuredImage: 'uploads/article3.jpg',
        publishedAt: new Date()
      },
      {
        title: 'Signs of Illness in Pets',
        category: 'Health & Wellness',
        body: 'Early detection of illness can save your pet\'s life. Watch for changes in appetite, energy levels, bathroom habits, and behavior. Vomiting, diarrhea, excessive thirst, or difficulty breathing require immediate attention. Regular vet checkups help catch problems early.',
        excerpt: 'Recognizing early warning signs of pet illness',
        tags: ['health', 'symptoms', 'veterinary care', 'prevention'],
        status: 'published',
        featuredImage: 'uploads/article4.jpg',
        publishedAt: new Date()
      },
      {
        title: 'Creating a Safe Environment for Indoor Cats',
        category: 'Safety',
        body: 'Indoor cats need environmental enrichment for mental and physical health. Provide vertical spaces like cat trees, hiding spots, and perches near windows. Remove toxic plants and secure dangerous items. Create multiple feeding and water stations. Provide various toys and rotate them regularly.',
        excerpt: 'Making your home safe and stimulating for indoor cats',
        tags: ['indoor cats', 'safety', 'environment', 'enrichment'],
        status: 'published',
        featuredImage: 'uploads/article5.jpg',
        publishedAt: new Date()
      }
    ];

    const articlesWithRefs = sampleArticles.map((article, index) => ({
      ...article,
      author: businesses[index % businesses.length]._id,
      relatedProducts: [products[index % products.length]._id]
    }));

    const articles = await Article.insertMany(articlesWithRefs);
    console.log(`✅ ${articles.length} articles seeded successfully`);
    return articles;
  } catch (error) {
    console.error('Error seeding articles:', error);
    throw error;
  }
};

const seedReviews = async (users) => {
  try {
    const existingReviews = await Review.countDocuments();
    if (existingReviews > 0) {
      console.log('Reviews already exist, skipping review seeding...');
      return await Review.find();
    }

    console.log('Seeding reviews...');
    const petOwners = users.filter(user => user.userType === 'Pet Owner');
    const businesses = users.filter(user => user.userType === 'Business');

    const sampleReviews = [
      {
        rating: 5,
        reviewText: 'Excellent service! The staff was very professional and my dog loved the grooming session. Highly recommended!',
        images: ['uploads/review1.jpg']
      },
      {
        rating: 4,
        reviewText: 'Great veterinary care. Dr. Smith was thorough and explained everything clearly. The facility is clean and modern.',
        images: []
      },
      {
        rating: 5,
        reviewText: 'Amazing training program! My puppy learned so much in just 6 weeks. The trainer was patient and knowledgeable.',
        images: ['uploads/review3.jpg']
      },
      {
        rating: 4,
        reviewText: 'Good boarding service. My cat was well taken care of while I was away. Regular updates were appreciated.',
        images: []
      },
      {
        rating: 5,
        reviewText: 'Best dog walking service in town! My dog is always excited when they arrive. Very reliable and trustworthy.',
        images: ['uploads/review5.jpg']
      }
    ];

    // Create unique reviewer-business combinations to avoid duplicate key errors
    // We have 2 pet owners and 3 businesses, so we can create max 6 unique combinations
    const reviewsWithRefs = [
      {
        ...sampleReviews[0],
        reviewer: petOwners[0]._id,
        business: businesses[0]._id  // petOwner1 → business1
      },
      {
        ...sampleReviews[1],
        reviewer: petOwners[1]._id,
        business: businesses[1]._id  // petOwner2 → business2
      },
      {
        ...sampleReviews[2],
        reviewer: petOwners[0]._id,
        business: businesses[2]._id  // petOwner1 → business3
      },
      {
        ...sampleReviews[3],
        reviewer: petOwners[1]._id,
        business: businesses[0]._id  // petOwner2 → business1
      },
      {
        ...sampleReviews[4],
        reviewer: petOwners[1]._id,
        business: businesses[2]._id  // petOwner2 → business3
      }
    ];

    const reviews = await Review.insertMany(reviewsWithRefs);
    console.log(`✅ ${reviews.length} reviews seeded successfully`);
    return reviews;
  } catch (error) {
    console.error('Error seeding reviews:', error);
    throw error;
  }
};

const seedAppointments = async (users, pets, services) => {
  try {
    const existingAppointments = await Appointment.countDocuments();
    if (existingAppointments > 0) {
      console.log('Appointments already exist, skipping appointment seeding...');
      return await Appointment.find();
    }

    console.log('Seeding appointments...');
    const petOwners = users.filter(user => user.userType === 'Pet Owner');
    const businesses = users.filter(user => user.userType === 'Business');

    const sampleAppointments = [
      {
        appointmentDate: new Date('2024-02-15'),
        appointmentTime: '10:00',
        subtotal: 150,
        tax: 12,
        total: 162,
        status: 'upcoming',
        notes: 'First time visit'
      },
      {
        appointmentDate: new Date('2024-02-20'),
        appointmentTime: '14:30',
        subtotal: 80,
        tax: 6.4,
        total: 86.4,
        status: 'completed',
        notes: 'Regular grooming session'
      },
      {
        appointmentDate: new Date('2024-02-25'),
        appointmentTime: '09:15',
        subtotal: 200,
        tax: 16,
        total: 216,
        status: 'upcoming',
        notes: 'Training consultation'
      },
      {
        appointmentDate: new Date('2024-03-01'),
        appointmentTime: '16:00',
        subtotal: 50,
        tax: 4,
        total: 54,
        status: 'upcoming',
        notes: 'Boarding check-in'
      },
      {
        appointmentDate: new Date('2024-03-05'),
        appointmentTime: '11:30',
        subtotal: 25,
        tax: 2,
        total: 27,
        status: 'completed',
        notes: 'Daily walk service'
      }
    ];

    const appointmentsWithRefs = sampleAppointments.map((appointment, index) => ({
      ...appointment,
      customer: petOwners[index % petOwners.length]._id,
      business: businesses[index % businesses.length]._id,
      pet: pets[index % pets.length]._id,
      service: services[index % services.length]._id,
      bookingId: `APT-SEED-${Date.now()}-${index}` // Ensure unique bookingId for each seed
    }));

    const appointments = await Appointment.insertMany(appointmentsWithRefs);
    console.log(`✅ ${appointments.length} appointments seeded successfully`);
    return appointments;
  } catch (error) {
    console.error('Error seeding appointments:', error);
    throw error;
  }
};

const seedOrders = async (users, products) => {
  try {
    const existingOrders = await Order.countDocuments();
    if (existingOrders > 0) {
      console.log('Orders already exist, skipping order seeding...');
      return await Order.find();
    }

    console.log('Seeding orders...');
    const petOwners = users.filter(user => user.userType === 'Pet Owner');

    const sampleOrders = [
      {
        status: 'delivered',
        paymentStatus: 'paid',
        subtotal: 45.99,
        shippingCost: 5.99,
        tax: 4.16,
        total: 56.14,
        shippingAddress: {
          street: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '12345',
          country: 'USA'
        }
      },
      {
        status: 'shipped',
        paymentStatus: 'paid',
        subtotal: 24.99,
        shippingCost: 7.99,
        tax: 2.64,
        total: 35.62,
        shippingAddress: {
          street: '456 Oak Ave',
          city: 'Los Angeles',
          state: 'CA',
          zipCode: '12346',
          country: 'USA'
        }
      },
      {
        status: 'pending',
        paymentStatus: 'paid',
        subtotal: 19.99,
        shippingCost: 3.99,
        tax: 1.92,
        total: 25.90
      },
      {
        status: 'delivered',
        paymentStatus: 'paid',
        subtotal: 89.99,
        shippingCost: 9.99,
        tax: 8.00,
        total: 107.98
      },
      {
        status: 'subscription',
        paymentStatus: 'paid',
        subtotal: 29.99,
        shippingCost: 4.99,
        tax: 2.80,
        total: 37.78,
        deliveryFrequency: 'monthly',
        nextDeliveryDate: new Date('2024-03-15')
      }
    ];

    const ordersWithRefs = sampleOrders.map((order, index) => {
      const product = products[index % products.length];
      return {
        ...order,
        user: petOwners[index % petOwners.length]._id,
        products: [{
          product: product._id,
          quantity: 1,
          price: product.price,
          total: product.price
        }]
      };
    });

    const orders = await Order.insertMany(ordersWithRefs);
    console.log(`✅ ${orders.length} orders seeded successfully`);
    return orders;
  } catch (error) {
    console.error('Error seeding orders:', error);
    throw error;
  }
};

// Main seeder function
const runSeeder = async () => {
  try {
    console.log('🌱 Starting database seeding...\n');

    // Seed in order due to dependencies
    const users = await seedUsers();
    const categories = await seedCategories();
    const pets = await seedPets(users);
    const services = await seedServices(users, categories);
    const products = await seedProducts(users);
    const articles = await seedArticles(users, products);
    const reviews = await seedReviews(users);
    const appointments = await seedAppointments(users, pets, services);
    const orders = await seedOrders(users, products);
    await seedAdoptions();

    console.log('\n🎉 Database seeding completed successfully!');
    console.log('📊 Summary:');
    console.log(`   - Users: ${users.length} (1 Admin + 2 Pet Owners + 3 Businesses)`);
    console.log(`   - Categories: ${categories.length}`);
    console.log(`   - Pets: ${pets.length}`);
    console.log(`   - Services: ${services.length}`);
    console.log(`   - Products: ${products.length}`);
    console.log(`   - Articles: ${articles.length}`);
    console.log(`   - Reviews: ${reviews.length}`);
    console.log(`   - Appointments: ${appointments.length}`);
    console.log(`   - Orders: ${orders.length}`);
    console.log(`   - Adoptions: Sample adoption listings created`);

  } catch (error) {
    console.error('❌ Error during database seeding:', error);
    throw error;
  }
};

module.exports = { runSeeder };
