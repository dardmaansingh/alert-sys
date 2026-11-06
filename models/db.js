const mongoose = require('mongoose');

async function connectDB(uri = 'mongodb://localhost:27017/alert_system') {
  try {
    await mongoose.connect(uri);
    console.log('MongoDB connected successfully');
  } catch (err) {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  }
}

module.exports = connectDB;
