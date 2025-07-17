const mongoose = require('mongoose');
require('dotenv').config();

async function fixOrderNumberIndex() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/petdash');
    console.log('Connected to MongoDB');

    const db = mongoose.connection.db;
    const ordersCollection = db.collection('orders');

    // Check existing indexes
    console.log('Checking existing indexes...');
    const indexes = await ordersCollection.indexes();
    console.log('Current indexes:', indexes.map(idx => ({ name: idx.name, key: idx.key })));

    // Drop the problematic orderNumber index if it exists
    try {
      await ordersCollection.dropIndex('orderNumber_1');
      console.log('✅ Dropped old orderNumber_1 index');
    } catch (error) {
      if (error.code === 27) {
        console.log('ℹ️  orderNumber_1 index does not exist, skipping drop');
      } else {
        console.log('Error dropping index:', error.message);
      }
    }

    // Create new sparse index for orderNumber
    await ordersCollection.createIndex(
      { orderNumber: 1 }, 
      { 
        unique: true, 
        sparse: true,
        name: 'orderNumber_1_sparse'
      }
    );
    console.log('✅ Created new sparse index for orderNumber');

    // Clean up any existing cart orders with null orderNumber issues
    const result = await ordersCollection.updateMany(
      { status: 'cart', orderNumber: null },
      { $unset: { orderNumber: "" } }
    );
    console.log(`✅ Cleaned up ${result.modifiedCount} cart orders`);

    // Verify the fix
    const cartCount = await ordersCollection.countDocuments({ status: 'cart' });
    console.log(`ℹ️  Found ${cartCount} cart orders`);

    console.log('\n🎉 Database fix completed successfully!');
    console.log('You can now add items to cart without the duplicate key error.');

  } catch (error) {
    console.error('❌ Error fixing database:', error);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB');
  }
}

console.log('🔧 Fixing orderNumber index issue...\n');
fixOrderNumberIndex();
