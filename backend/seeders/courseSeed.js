const Course = require('../models/Course');
const User = require('../models/User');

const sampleCourses = [
  {
    title: "Puppy Basics",
    description: "Complete guide to puppy training fundamentals. Learn essential commands, house training, and socialization techniques that will set your puppy up for success.",
    shortDescription: "Essential puppy training fundamentals for new pet owners",
    category: "Puppy Basics",
    difficulty: "Beginner",
    difficultyLevel: 1,
    price: 49,
    originalPrice: 69,
    duration: 180, // 3 hours
    estimatedCompletionTime: "2-3 weeks",
    coverImage: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=500",
    thumbnailImage: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=300",
    videoPreview: "https://example.com/puppy-basics-preview.mp4",
    trainingType: "online",
    isFeatured: true,
    isPopular: true,
    learningObjectives: [
      "Basic commands: sit, stay, come",
      "House training techniques",
      "Proper socialization methods",
      "Feeding and nutrition basics",
      "Understanding puppy behavior"
    ],
    prerequisites: [],
    tags: ["puppy", "basic", "training", "beginner", "commands"],
    steps: [
      {
        title: "Getting Sally comfortable",
        description: "Learn how to make your puppy feel safe and comfortable in their new environment",
        content: "Creating a comfortable environment for your puppy is crucial for successful training. Start by setting up a designated space with their bed, toys, and water bowl. Speak in calm, reassuring tones and allow your puppy to explore at their own pace. Avoid overwhelming them with too many new experiences at once.",
        videoUrl: "https://example.com/step1-video.mp4",
        imageUrl: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400",
        duration: 15,
        order: 1
      },
      {
        title: "Basic Commands - Sit",
        description: "Teach your puppy the fundamental 'sit' command",
        content: "The 'sit' command is one of the most important basic commands. Hold a treat close to your puppy's nose, slowly lift your hand up, allowing their head to follow the treat. As their head moves up, their bottom will naturally lower. Once they're sitting, say 'Sit', give them the treat and praise them. Practice this 5-10 times per session.",
        videoUrl: "https://example.com/sit-command.mp4",
        imageUrl: "https://images.unsplash.com/photo-1551717743-49959800b1f6?w=400",
        duration: 20,
        order: 2
      },
      {
        title: "House Training Basics",
        description: "Essential techniques for house training your puppy",
        content: "Establish a consistent routine for feeding, watering, and bathroom breaks. Take your puppy outside first thing in the morning, after meals, after naps, and before bedtime. Choose a specific spot outside and use a command like 'go potty'. Reward immediately when they go in the right place. Never punish accidents - simply clean up and continue the routine.",
        videoUrl: "https://example.com/house-training.mp4",
        imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400",
        duration: 25,
        order: 3
      }
    ],
    badges: [
      {
        name: "Puppy Starter",
        description: "Completed first puppy training lesson",
        icon: "🐕",
        color: "#FFD700",
        criteria: "Complete first step"
      },
      {
        name: "Command Master",
        description: "Mastered basic puppy commands",
        icon: "⭐",
        color: "#FF6B6B",
        criteria: "Complete 50% of course"
      },
      {
        name: "Puppy Graduate",
        description: "Successfully completed puppy basics course",
        icon: "🎓",
        color: "#4ECDC4",
        criteria: "Complete 100% of course"
      }
    ]
  },
  {
    title: "Adult Dog Training",
    description: "Advanced training techniques for adult dogs. Perfect for rescue dogs or dogs that need behavioral correction and advanced command training.",
    shortDescription: "Advanced training for adult dogs and behavioral correction",
    category: "Adult Basics",
    difficulty: "Intermediate",
    difficultyLevel: 3,
    price: 79,
    originalPrice: 99,
    duration: 240, // 4 hours
    estimatedCompletionTime: "3-4 weeks",
    coverImage: "https://images.unsplash.com/photo-1552053831-71594a27632d?w=500",
    thumbnailImage: "https://images.unsplash.com/photo-1552053831-71594a27632d?w=300",
    trainingType: "online",
    isPopular: true,
    learningObjectives: [
      "Advanced obedience commands",
      "Behavioral problem solving",
      "Leash training for adults",
      "Socialization with other dogs",
      "Impulse control techniques"
    ],
    prerequisites: ["Basic understanding of dog behavior"],
    tags: ["adult", "advanced", "behavior", "obedience", "correction"],
    steps: [
      {
        title: "Assessment and Goal Setting",
        description: "Evaluate your dog's current behavior and set training goals",
        content: "Before starting advanced training, assess your dog's current skill level and identify specific behavioral issues. Create a training plan with realistic goals and timelines. Document problem behaviors and their triggers to address them systematically.",
        duration: 30,
        order: 1
      },
      {
        title: "Advanced Commands",
        description: "Teach complex commands like 'heel', 'place', and 'wait'",
        content: "Build on basic commands with more complex instructions. The 'heel' command teaches your dog to walk beside you without pulling. 'Place' teaches them to go to a specific location and stay. 'Wait' builds impulse control. Practice each command in short sessions with high-value rewards.",
        duration: 45,
        order: 2
      }
    ],
    badges: [
      {
        name: "Adult Trainer",
        description: "Started adult dog training program",
        icon: "🐕‍🦺",
        color: "#9B59B6",
        criteria: "Complete first step"
      }
    ]
  },
  {
    title: "Professional Grooming Basics",
    description: "Learn professional grooming techniques to keep your dog looking and feeling their best. Covers brushing, bathing, nail trimming, and basic styling.",
    shortDescription: "Professional grooming techniques for dog owners",
    category: "Grooming",
    difficulty: "Beginner",
    difficultyLevel: 2,
    price: 59,
    duration: 150, // 2.5 hours
    estimatedCompletionTime: "1-2 weeks",
    coverImage: "https://images.unsplash.com/photo-1560807707-8cc77767d783?w=500",
    thumbnailImage: "https://images.unsplash.com/photo-1560807707-8cc77767d783?w=300",
    trainingType: "online",
    isFeatured: true,
    learningObjectives: [
      "Proper brushing techniques",
      "Safe bathing procedures",
      "Nail trimming basics",
      "Ear cleaning methods",
      "Basic styling and finishing"
    ],
    tags: ["grooming", "hygiene", "care", "maintenance", "health"],
    steps: [
      {
        title: "Grooming Tools and Setup",
        description: "Essential tools and workspace preparation for grooming",
        content: "Set up a safe, comfortable grooming area with proper lighting and non-slip surfaces. Essential tools include quality brushes, nail clippers, dog shampoo, towels, and a blow dryer. Always have treats ready to make the experience positive for your dog.",
        duration: 20,
        order: 1
      }
    ],
    badges: [
      {
        name: "Grooming Apprentice",
        description: "Started grooming training",
        icon: "✂️",
        color: "#E74C3C",
        criteria: "Complete first step"
      }
    ]
  },
  {
    title: "Leash Training Mastery",
    description: "Master the art of leash training for dogs of all ages. Learn techniques to stop pulling, improve heel command, and make walks enjoyable for both you and your dog.",
    shortDescription: "Complete guide to leash training and walking etiquette",
    category: "Leash Training",
    difficulty: "Intermediate",
    difficultyLevel: 2,
    price: 39,
    duration: 120, // 2 hours
    estimatedCompletionTime: "2-3 weeks",
    coverImage: "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=500",
    thumbnailImage: "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=300",
    trainingType: "online",
    learningObjectives: [
      "Stop leash pulling behavior",
      "Perfect heel command",
      "Proper leash equipment selection",
      "Walking etiquette and safety",
      "Distraction management"
    ],
    tags: ["leash", "walking", "heel", "pulling", "exercise"],
    steps: [
      {
        title: "Leash Equipment Basics",
        description: "Choose the right leash and collar for your dog",
        content: "Selecting proper equipment is crucial for successful leash training. Use a standard 6-foot leash for training, avoid retractable leashes initially. Choose a well-fitted collar or harness based on your dog's size and pulling tendency. Front-clip harnesses can help reduce pulling.",
        duration: 15,
        order: 1
      }
    ],
    badges: [
      {
        name: "Walking Partner",
        description: "Started leash training journey",
        icon: "🚶‍♂️",
        color: "#3498DB",
        criteria: "Complete first step"
      }
    ]
  }
];

const seedCourses = async () => {
  try {
    // Find an admin user to assign as course creator
    let adminUser = await User.findOne({ userType: 'Admin' });
    
    // If no admin exists, create one
    if (!adminUser) {
      adminUser = new User({
        name: 'Course Admin',
        email: 'admin@petpatch.com',
        password: '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // password
        userType: 'Admin',
        phoneNumber: '+1234567890',
        addresses: [{
          label: 'Admin Office',
          streetName: '123 Admin Street',
          city: 'Admin City',
          state: 'AC',
          zipCode: '12345',
          isPrimary: true
        }]
      });
      await adminUser.save();
      console.log('✅ Admin user created for courses');
    }

    // Clear existing courses
    await Course.deleteMany({});
    console.log('🗑️  Cleared existing courses');

    // Add creator ID to each course
    const coursesWithCreator = sampleCourses.map(course => ({
      ...course,
      createdBy: adminUser._id
    }));

    // Insert sample courses
    const insertedCourses = await Course.insertMany(coursesWithCreator);
    console.log(`✅ Inserted ${insertedCourses.length} sample courses`);

    return insertedCourses;
  } catch (error) {
    console.error('❌ Error seeding courses:', error);
    throw error;
  }
};

module.exports = { seedCourses };
