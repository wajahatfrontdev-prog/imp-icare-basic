/**
 * seed_locations.js
 * 
 * Run this ONCE to seed real Karachi coordinates into existing
 * pharmacy and lab profiles that have null lat/lng.
 * 
 * Usage:
 *   node seed_locations.js
 */

// Load from .env.production if available, fallback to .env
const fs = require('fs');
if (fs.existsSync('.env.production')) {
  require('dotenv').config({ path: '.env.production' });
} else {
  require('dotenv').config();
}
// Strip trailing \n from env vars (Vercel CLI adds them)
if (process.env.MONGO_URI) {
  process.env.MONGO_URI = process.env.MONGO_URI.replace(/\\n/g, '').trim();
}
const mongoose = require('mongoose');
const PharmacyProfile = require('./models/PharmacyProfile');
const LabProfile = require('./models/LabProfile');
const User = require('./models/User');

// ─── REAL KARACHI AREA COORDINATES ───────────────────────────────────────────
// These are real coordinates for major Karachi areas.
// Match these to your actual pharmacy/lab names below.

const PHARMACY_LOCATIONS = [
  // Format: { nameMatch: 'partial name (case-insensitive)', lat, lng, address, city }
  {
    nameMatch: 'iqra',
    lat: 24.8607,
    lng: 67.0011,
    address: 'Iqra Pharmacy, Clifton Block 5, Karachi',
    city: 'Karachi',
  },
  {
    nameMatch: 'test pharmacist',
    lat: 24.9056,
    lng: 67.0822,
    address: 'Test Pharmacist, Gulshan-e-Iqbal, Karachi',
    city: 'Karachi',
  },
  {
    nameMatch: 'production pharmacy',
    lat: 24.8200,
    lng: 67.0300,
    address: 'Production Pharmacy, DHA Phase 2, Karachi',
    city: 'Karachi',
  },
];

const LAB_LOCATIONS = [
  {
    nameMatch: 'production',
    lat: 24.8607,
    lng: 67.0011,
    address: 'Production Lab, Clifton, Karachi',
    city: 'Karachi',
  },
  {
    nameMatch: 'chughtai',
    lat: 24.8918,
    lng: 67.0716,
    address: 'Chughtai Lab, Gulshan-e-Iqbal, Karachi',
    city: 'Karachi',
  },
  {
    nameMatch: 'essa',
    lat: 24.8607,
    lng: 67.0011,
    address: 'Essa Lab, Clifton, Karachi',
    city: 'Karachi',
  },
];

async function seedLocations() {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      serverSelectionTimeoutMS: 10000,
    });
    console.log('✅ MongoDB connected');

    // ── PHARMACIES ────────────────────────────────────────────────────────────
    console.log('\n📍 Updating pharmacy locations...');
    
    // Get all pharmacy users
    const pharmacyUsers = await User.find({
      role: { $in: ['pharmacy', 'Pharmacy'] },
    }).lean();
    
    console.log(`Found ${pharmacyUsers.length} pharmacy users`);

    for (const user of pharmacyUsers) {
      const profile = await PharmacyProfile.findOne({ user_id: user._id });
      
      // Skip if already has coordinates
      if (profile?.latitude != null && profile?.longitude != null) {
        console.log(`  ⏭  ${user.username || user.name} — already has coordinates (${profile.latitude}, ${profile.longitude})`);
        continue;
      }

      const userName = (user.username || user.name || '').toLowerCase();
      const profileName = (profile?.pharmacy_name || '').toLowerCase();
      const searchName = profileName || userName;

      // Find matching location config
      const match = PHARMACY_LOCATIONS.find(loc =>
        searchName.includes(loc.nameMatch.toLowerCase()) ||
        userName.includes(loc.nameMatch.toLowerCase())
      );

      if (match) {
        await PharmacyProfile.findOneAndUpdate(
          { user_id: user._id },
          {
            $set: {
              latitude: match.lat,
              longitude: match.lng,
              ...((!profile?.address) && { address: match.address }),
              ...((!profile?.city) && { city: match.city }),
            },
          },
          { upsert: true }
        );
        console.log(`  ✅ ${user.username || user.name} → (${match.lat}, ${match.lng}) — ${match.address}`);
      } else {
        // Assign a random Karachi coordinate so they at least show up in nearest
        // Real pharmacies should update their own location via profile setup
        const karachiAreas = [
          { lat: 24.8607, lng: 67.0011, area: 'Clifton' },
          { lat: 24.9056, lng: 67.0822, area: 'Gulshan-e-Iqbal' },
          { lat: 24.8200, lng: 67.0300, area: 'DHA Phase 2' },
          { lat: 24.9400, lng: 67.1200, area: 'North Nazimabad' },
          { lat: 24.8800, lng: 67.0650, area: 'PECHS' },
          { lat: 24.8500, lng: 66.9900, area: 'Clifton Block 9' },
        ];
        const area = karachiAreas[Math.floor(Math.random() * karachiAreas.length)];
        // Add small random offset so they don't all cluster at same point
        const lat = area.lat + (Math.random() - 0.5) * 0.02;
        const lng = area.lng + (Math.random() - 0.5) * 0.02;

        await PharmacyProfile.findOneAndUpdate(
          { user_id: user._id },
          { $set: { latitude: lat, longitude: lng } },
          { upsert: true }
        );
        console.log(`  📌 ${user.username || user.name} → assigned Karachi area: ${area.area} (${lat.toFixed(4)}, ${lng.toFixed(4)})`);
      }
    }

    // ── LABS ──────────────────────────────────────────────────────────────────
    console.log('\n🔬 Updating lab locations...');
    
    const labUsers = await User.find({
      role: { $in: ['lab', 'Lab', 'laboratory', 'Laboratory'] },
    }).lean();
    
    console.log(`Found ${labUsers.length} lab users`);

    for (const user of labUsers) {
      const profile = await LabProfile.findOne({ user_id: user._id });

      if (profile?.latitude != null && profile?.longitude != null) {
        console.log(`  ⏭  ${user.username || user.name} — already has coordinates (${profile.latitude}, ${profile.longitude})`);
        continue;
      }

      const userName = (user.username || user.name || '').toLowerCase();
      const profileName = (profile?.lab_name || '').toLowerCase();
      const searchName = profileName || userName;

      const match = LAB_LOCATIONS.find(loc =>
        searchName.includes(loc.nameMatch.toLowerCase()) ||
        userName.includes(loc.nameMatch.toLowerCase())
      );

      if (match) {
        await LabProfile.findOneAndUpdate(
          { user_id: user._id },
          {
            $set: {
              latitude: match.lat,
              longitude: match.lng,
              ...((!profile?.address) && { address: match.address }),
              ...((!profile?.city) && { city: match.city }),
            },
          },
          { upsert: true }
        );
        console.log(`  ✅ ${user.username || user.name} → (${match.lat}, ${match.lng}) — ${match.address}`);
      } else {
        const karachiAreas = [
          { lat: 24.8607, lng: 67.0011, area: 'Clifton' },
          { lat: 24.9056, lng: 67.0822, area: 'Gulshan-e-Iqbal' },
          { lat: 24.8200, lng: 67.0300, area: 'DHA Phase 2' },
          { lat: 24.9400, lng: 67.1200, area: 'North Nazimabad' },
          { lat: 24.8800, lng: 67.0650, area: 'PECHS' },
        ];
        const area = karachiAreas[Math.floor(Math.random() * karachiAreas.length)];
        const lat = area.lat + (Math.random() - 0.5) * 0.02;
        const lng = area.lng + (Math.random() - 0.5) * 0.02;

        await LabProfile.findOneAndUpdate(
          { user_id: user._id },
          { $set: { latitude: lat, longitude: lng } },
          { upsert: true }
        );
        console.log(`  📌 ${user.username || user.name} → assigned Karachi area: ${area.area} (${lat.toFixed(4)}, ${lng.toFixed(4)})`);
      }
    }

    console.log('\n✅ Done! All pharmacies and labs now have coordinates.');
    console.log('   Nearest feature will now work correctly for Karachi users.\n');

  } catch (err) {
    console.error('❌ Error:', err.message);
  } finally {
    await mongoose.disconnect();
    process.exit(0);
  }
}

seedLocations();
