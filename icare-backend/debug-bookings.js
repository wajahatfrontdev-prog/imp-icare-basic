const mongoose = require('mongoose');
const { connectMongoDB } = require('./config/mongodb');
const User = require('./models/User');
const LabTestRequest = require('./models/LabTestRequest');
const PharmacyOrder = require('./models/PharmacyOrder');

async function debugBookings() {
  try {
    await connectMongoDB();
    console.log('✅ Connected to MongoDB\n');

    // Check lab users
    console.log('=== LAB USERS ===');
    const labUsers = await User.find({ role: 'Laboratory' }).lean();
    console.log(`Found ${labUsers.length} lab users with role "Laboratory"`);
    labUsers.forEach(u => {
      console.log(`  - ${u.username || u.name} (${u.email})`);
      console.log(`    ID: ${u._id.toString()}`);
    });

    // Check for role variations
    const labUsersLowercase = await User.find({ role: 'laboratory' }).lean();
    console.log(`Found ${labUsersLowercase.length} lab users with role "laboratory" (lowercase)`);

    const labUsersLab = await User.find({ role: 'lab' }).lean();
    console.log(`Found ${labUsersLab.length} lab users with role "lab"\n`);

    // Check pharmacy users
    console.log('=== PHARMACY USERS ===');
    const pharmacyUsers = await User.find({ role: 'Pharmacy' }).lean();
    console.log(`Found ${pharmacyUsers.length} pharmacy users with role "Pharmacy"`);
    pharmacyUsers.forEach(u => {
      console.log(`  - ${u.username || u.name} (${u.email})`);
      console.log(`    ID: ${u._id.toString()}`);
    });

    const pharmacyUsersLowercase = await User.find({ role: 'pharmacy' }).lean();
    console.log(`Found ${pharmacyUsersLowercase.length} pharmacy users with role "pharmacy" (lowercase)\n`);

    // Check all lab bookings
    console.log('=== ALL LAB BOOKINGS ===');
    const allLabBookings = await LabTestRequest.find({}).lean();
    console.log(`Total lab bookings in database: ${allLabBookings.length}`);
    allLabBookings.forEach(b => {
      console.log(`  - Booking ID: ${b._id.toString()}`);
      console.log(`    Lab ID: ${b.lab_id.toString()}`);
      console.log(`    Patient ID: ${b.patient_id.toString()}`);
      console.log(`    Test: ${b.test_type}`);
      console.log(`    Status: ${b.status}`);
      console.log(`    Created: ${b.createdAt}\n`);
    });

    // Check all pharmacy orders
    console.log('=== ALL PHARMACY ORDERS ===');
    const allPharmacyOrders = await PharmacyOrder.find({}).lean();
    console.log(`Total pharmacy orders in database: ${allPharmacyOrders.length}`);
    allPharmacyOrders.forEach(o => {
      console.log(`  - Order ID: ${o._id.toString()}`);
      console.log(`    Pharmacy ID: ${o.pharmacy_id.toString()}`);
      console.log(`    Patient ID: ${o.patient_id.toString()}`);
      console.log(`    Status: ${o.status}`);
      console.log(`    Total: ${o.total_amount}`);
      console.log(`    Created: ${o.createdAt}\n`);
    });

    // Check specific lab user
    const specificLabId = '69c2c9088abbbbbc1def348b';
    console.log(`=== CHECKING SPECIFIC LAB: ${specificLabId} ===`);
    const specificLab = await User.findById(specificLabId).lean();
    if (specificLab) {
      console.log(`Found user: ${specificLab.username || specificLab.name}`);
      console.log(`Role: ${specificLab.role}`);
      console.log(`Email: ${specificLab.email}\n`);

      const bookingsForThisLab = await LabTestRequest.find({ lab_id: specificLabId }).lean();
      console.log(`Bookings for this lab: ${bookingsForThisLab.length}`);
    } else {
      console.log('Lab user not found!\n');
    }

    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

debugBookings();
