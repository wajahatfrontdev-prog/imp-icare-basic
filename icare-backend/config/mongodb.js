const mongoose = require('mongoose');
require('dotenv').config(); // Load .env file

// In serverless environments, reuse existing connection across warm invocations
const connectMongoDB = async () => {
  if (mongoose.connection.readyState === 1) return; // already connected
  if (mongoose.connection.readyState === 2) {
    // connecting — wait for it
    await new Promise((resolve, reject) => {
      mongoose.connection.once('connected', resolve);
      mongoose.connection.once('error', reject);
    });
    return;
  }
  const uri = (process.env.MONGO_URI || process.env.MONGODB_URI || '').trim();
  if (!uri) {
    const err = new Error('MONGO_URI or MONGODB_URI environment variable is not set');
    console.error('❌ MongoDB connection error:', err.message);
    throw err;
  }
  try {
    await mongoose.connect(uri, {
      serverSelectionTimeoutMS: 4000,
      connectTimeoutMS: 4000,
      socketTimeoutMS: 8000,
      maxPoolSize: 10,
      minPoolSize: 1,
      maxIdleTimeMS: 10000,
      waitQueueTimeoutMS: 4000, // fail fast if pool is full
    });
    console.log('✅ MongoDB connected');
  } catch (err) {
    console.error('❌ MongoDB connection error:', err.message);
    throw err;
  }
};

module.exports = { connectMongoDB };
