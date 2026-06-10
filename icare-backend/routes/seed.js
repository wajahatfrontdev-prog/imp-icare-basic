const express = require('express');
const router = express.Router();
const { connectMongoDB } = require('../config/mongodb');
const User = require('../models/User');
const Product = require('../models/Product');

const SAMPLE_PRODUCTS = [
  { name: 'Panadol (Paracetamol 500mg)', generic_name: 'Paracetamol', manufacturer: 'GSK Pakistan', price: 35, stock_quantity: 200, medicine_category: 'OTC', requires_prescription: false, description: 'Pain reliever and fever reducer' },
  { name: 'Brufen (Ibuprofen 400mg)', generic_name: 'Ibuprofen', manufacturer: 'Abbott Pakistan', price: 85, stock_quantity: 150, medicine_category: 'OTC', requires_prescription: false, description: 'Anti-inflammatory pain reliever' },
  { name: 'Augmentin (Amoxicillin 625mg)', generic_name: 'Amoxicillin+Clavulanate', manufacturer: 'GSK Pakistan', price: 420, stock_quantity: 80, medicine_category: 'OTC', requires_prescription: true, description: 'Antibiotic for bacterial infections' },
  { name: 'Risek (Omeprazole 20mg)', generic_name: 'Omeprazole', manufacturer: 'Getz Pharma', price: 180, stock_quantity: 120, medicine_category: 'OTC', requires_prescription: false, description: 'Acid reflux and stomach ulcer treatment' },
  { name: 'Glucophage (Metformin 500mg)', generic_name: 'Metformin', manufacturer: 'Merck Pakistan', price: 95, stock_quantity: 100, medicine_category: 'OTC', requires_prescription: true, description: 'Diabetes management medication' },
  { name: 'Lipitor (Atorvastatin 20mg)', generic_name: 'Atorvastatin', manufacturer: 'Pfizer Pakistan', price: 320, stock_quantity: 60, medicine_category: 'OTC', requires_prescription: true, description: 'Cholesterol lowering medication' },
  { name: 'Disprin (Aspirin 300mg)', generic_name: 'Aspirin', manufacturer: 'Reckitt Pakistan', price: 25, stock_quantity: 300, medicine_category: 'OTC', requires_prescription: false, description: 'Pain relief and blood thinner' },
  { name: 'ORS Sachet (Oral Rehydration)', generic_name: 'ORS', manufacturer: 'National Pharma', price: 15, stock_quantity: 500, medicine_category: 'OTC', requires_prescription: false, description: 'Rehydration therapy for diarrhea' },
  { name: 'Flagyl (Metronidazole 400mg)', generic_name: 'Metronidazole', manufacturer: 'Sanofi Pakistan', price: 110, stock_quantity: 90, medicine_category: 'OTC', requires_prescription: true, description: 'Antibiotic for gut infections' },
  { name: 'Ventolin Inhaler (Salbutamol)', generic_name: 'Salbutamol', manufacturer: 'GSK Pakistan', price: 280, stock_quantity: 40, medicine_category: 'OTC', requires_prescription: true, description: 'Bronchodilator for asthma relief' },
];

// POST /api/seed/products — seed sample products for all pharmacies that have none
router.post('/products', async (req, res) => {
  try {
    await connectMongoDB();

    // Find all pharmacy users
    const pharmacies = await User.find({ role: { $in: ['Pharmacy', 'pharmacy'] } }).lean();
    if (pharmacies.length === 0) {
      return res.json({ success: false, message: 'No pharmacies found in database' });
    }

    let totalCreated = 0;
    for (const pharmacy of pharmacies) {
      const existing = await Product.countDocuments({ pharmacy_id: pharmacy._id });
      if (existing > 0) continue; // skip pharmacies that already have products

      const docs = SAMPLE_PRODUCTS.map(p => ({ ...p, pharmacy_id: pharmacy._id, is_active: true }));
      await Product.insertMany(docs);
      totalCreated += docs.length;
    }

    res.json({
      success: true,
      message: `Seeded ${totalCreated} products across ${pharmacies.length} pharmacies`,
      pharmaciesCount: pharmacies.length,
      productsCreated: totalCreated,
    });
  } catch (err) {
    console.error('Seed products error:', err);
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/seed — health check
router.all('/{*path}', (req, res) => {
  res.json({ success: true, message: 'Seed route. POST /api/seed/products to seed pharmacy inventory.' });
});

router.all('/', (req, res) => {
  res.json({ success: true, message: 'Seed route. POST /api/seed/products to seed pharmacy inventory.' });
});

module.exports = router;
