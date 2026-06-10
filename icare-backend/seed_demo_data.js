const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
require('dotenv').config();

// Models
const User = require('./models/User');
const DoctorProfile = require('./models/DoctorProfile');
const LabProfile = require('./models/LabProfile');
const PharmacyProfile = require('./models/PharmacyProfile');
const Product = require('./models/Product');

// MongoDB Connection
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI || process.env.MONGO_URI);
    console.log('✅ MongoDB Connected');
  } catch (error) {
    console.error('❌ MongoDB Connection Error:', error);
    process.exit(1);
  }
};

// Hash password
const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10);
  return await bcrypt.hash(password, salt);
};

// Seed Data
const seedData = async () => {
  try {
    console.log('🌱 Starting seed process...\n');

    // Clear existing demo data (optional - comment out if you want to keep existing data)
    // await User.deleteMany({ email: { $regex: /@demo\.icare\.com$/ } });
    // console.log('🗑️  Cleared existing demo data\n');

    // ═══════════════════════════════════════════════════════════════════════
    // 1. CREATE DOCTOR ACCOUNT
    // ═══════════════════════════════════════════════════════════════════════
    console.log('👨‍⚕️  Creating Doctor Account...');

    const doctorPassword = await hashPassword('Doctor@123');
    const doctor = await User.create({
      name: 'Dr. Ahmed Hassan',
      username: 'Dr. Ahmed Hassan',
      email: 'doctor@demo.icare.com',
      phone: '+923001234567',
      password: doctorPassword,
      role: 'doctor',
      is_approved: true,
      is_active: true,
      isApproved: true,
      isActive: true,
    });

    // Create Doctor Profile
    await DoctorProfile.create({
      user_id: doctor._id,
      specialization: 'General Physician',
      experience_years: 10,
      license_number: 'PMC-12345',
      consultation_fee: 2000,
      available_days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      available_hours: '9:00 AM - 5:00 PM',
      rating: 4.8,
      total_reviews: 156,
      degrees: ['MBBS', 'FCPS'],
      clinic_name: 'Hassan Medical Center',
      clinic_address: 'Clifton Block 5, Karachi',
      consultation_type: 'Both',
      languages: ['English', 'Urdu'],
    });

    console.log('✅ Doctor created: doctor@demo.icare.com / Doctor@123\n');

    // ═══════════════════════════════════════════════════════════════════════
    // 2. CREATE 4 PATIENT ACCOUNTS
    // ═══════════════════════════════════════════════════════════════════════
    console.log('👥 Creating 4 Patient Accounts...');

    const patientPassword = await hashPassword('Patient@123');
    const patients = [];

    const patientData = [
      { name: 'Ali Khan', email: 'patient1@demo.icare.com', phone: '+923011111111' },
      { name: 'Fatima Ahmed', email: 'patient2@demo.icare.com', phone: '+923022222222' },
      { name: 'Hassan Raza', email: 'patient3@demo.icare.com', phone: '+923033333333' },
      { name: 'Ayesha Malik', email: 'patient4@demo.icare.com', phone: '+923044444444' },
    ];

    for (const data of patientData) {
      const patient = await User.create({
        name: data.name,
        username: data.name,
        email: data.email,
        phone: data.phone,
        password: patientPassword,
        role: 'patient',
        is_approved: true,
        is_active: true,
        isApproved: true,
        isActive: true,
      });
      patients.push(patient);
      console.log(`✅ Patient created: ${data.email} / Patient@123`);
    }
    console.log('');

    // ═══════════════════════════════════════════════════════════════════════
    // 3. CREATE LAB ACCOUNT WITH TEST CATALOG
    // ═══════════════════════════════════════════════════════════════════════
    console.log('🔬 Creating Lab Account...');

    const labPassword = await hashPassword('Lab@123');
    const lab = await User.create({
      name: 'City Diagnostic Lab',
      username: 'City Diagnostic Lab',
      email: 'lab@demo.icare.com',
      phone: '+923055555555',
      password: labPassword,
      role: 'lab',
      is_approved: true,
      is_active: true,
      isApproved: true,
      isActive: true,
    });

    // Create Lab Profile
    await LabProfile.create({
      user_id: lab._id,
      lab_name: 'City Diagnostic Laboratory',
      license_number: 'LAB-2024-001',
      accreditation: 'CAP Accredited',
      services: [
        'Complete Blood Count (CBC)',
        'Lipid Profile',
        'Liver Function Test (LFT)',
        'Kidney Function Test (KFT)',
        'Thyroid Profile',
        'HbA1c (Diabetes)',
        'Vitamin D',
        'COVID-19 PCR',
      ],
      operating_hours: '8:00 AM - 8:00 PM',
      address: 'Main Boulevard, Gulberg, Lahore',
      city: 'Lahore',
      drap_compliance: true,
      rating: 4.7,
      total_reviews: 89,
    });

    console.log('✅ Lab created: lab@demo.icare.com / Lab@123\n');

    // ═══════════════════════════════════════════════════════════════════════
    // 4. CREATE PHARMACY ACCOUNT WITH INVENTORY
    // ═══════════════════════════════════════════════════════════════════════
    console.log('💊 Creating Pharmacy Account...');

    const pharmacyPassword = await hashPassword('Pharmacy@123');
    const pharmacy = await User.create({
      name: 'HealthCare Pharmacy',
      username: 'HealthCare Pharmacy',
      email: 'pharmacy@demo.icare.com',
      phone: '+923066666666',
      password: pharmacyPassword,
      role: 'pharmacy',
      is_approved: true,
      is_active: true,
      isApproved: true,
      isActive: true,
    });

    // Create Pharmacy Profile
    await PharmacyProfile.create({
      user_id: pharmacy._id,
      pharmacy_name: 'HealthCare Pharmacy',
      license_number: 'PHARM-2024-001',
      address: 'F-7 Markaz, Islamabad',
      city: 'Islamabad',
      operating_hours: '24/7',
      drap_compliance: true,
      rating: 4.9,
      total_reviews: 234,
    });

    console.log('✅ Pharmacy created: pharmacy@demo.icare.com / Pharmacy@123');

    // Add Pharmacy Inventory
    console.log('📦 Adding pharmacy inventory...');

    const medicines = [
      { name: 'Panadol', generic_name: 'Paracetamol', category: 'Pain Relief', price: 50, stock: 500, requires_prescription: false },
      { name: 'Brufen', generic_name: 'Ibuprofen', category: 'Pain Relief', price: 80, stock: 300, requires_prescription: false },
      { name: 'Augmentin', generic_name: 'Amoxicillin + Clavulanate', category: 'Antibiotics', price: 450, stock: 150, requires_prescription: true },
      { name: 'Azithromycin', generic_name: 'Azithromycin', category: 'Antibiotics', price: 350, stock: 200, requires_prescription: true },
      { name: 'Lipitor', generic_name: 'Atorvastatin', category: 'Cardiovascular', price: 600, stock: 100, requires_prescription: true },
      { name: 'Glucophage', generic_name: 'Metformin', category: 'Diabetes', price: 250, stock: 250, requires_prescription: true },
      { name: 'Ventolin Inhaler', generic_name: 'Salbutamol', category: 'Respiratory', price: 800, stock: 80, requires_prescription: true },
      { name: 'Omeprazole', generic_name: 'Omeprazole', category: 'Gastric', price: 150, stock: 400, requires_prescription: false },
      { name: 'Cetirizine', generic_name: 'Cetirizine', category: 'Allergy', price: 120, stock: 350, requires_prescription: false },
      { name: 'Vitamin D3', generic_name: 'Cholecalciferol', category: 'Supplements', price: 300, stock: 200, requires_prescription: false },
    ];

    for (const med of medicines) {
      await Product.create({
        pharmacy_id: pharmacy._id,
        name: med.name,
        generic_name: med.generic_name,
        description: `${med.name} - ${med.generic_name}`,
        category: med.category,
        medicine_category: 'OTC',
        price: med.price,
        stock_quantity: med.stock,
        manufacturer: 'Generic Pharma',
        requires_prescription: med.requires_prescription,
        is_active: true,
      });
    }

    console.log(`✅ Added ${medicines.length} medicines to inventory\n`);

    // ═══════════════════════════════════════════════════════════════════════
    // SUMMARY
    // ═══════════════════════════════════════════════════════════════════════
    console.log('═══════════════════════════════════════════════════════════');
    console.log('✅ SEED COMPLETED SUCCESSFULLY!');
    console.log('═══════════════════════════════════════════════════════════\n');

    console.log('📋 DEMO ACCOUNTS CREATED:\n');
    console.log('👨‍⚕️  DOCTOR:');
    console.log('   Email: doctor@demo.icare.com');
    console.log('   Password: Doctor@123');
    console.log('   Name: Dr. Ahmed Hassan');
    console.log('   Specialization: General Physician\n');

    console.log('👥 PATIENTS:');
    patientData.forEach((p, i) => {
      console.log(`   ${i + 1}. ${p.name}`);
      console.log(`      Email: ${p.email}`);
      console.log(`      Password: Patient@123\n`);
    });

    console.log('🔬 LAB:');
    console.log('   Email: lab@demo.icare.com');
    console.log('   Password: Lab@123');
    console.log('   Name: City Diagnostic Laboratory\n');

    console.log('💊 PHARMACY:');
    console.log('   Email: pharmacy@demo.icare.com');
    console.log('   Password: Pharmacy@123');
    console.log('   Name: HealthCare Pharmacy');
    console.log('   Inventory: 10 medicines added\n');

    console.log('═══════════════════════════════════════════════════════════');
    console.log('🎯 NEXT STEPS FOR DEMO:');
    console.log('═══════════════════════════════════════════════════════════');
    console.log('1. Login as Patient (any of the 4 accounts)');
    console.log('2. Book appointment with Dr. Ahmed Hassan');
    console.log('3. Login as Doctor to accept appointment');
    console.log('4. Complete consultation and create prescription');
    console.log('5. Patient sends prescription to pharmacy');
    console.log('6. Login as Pharmacy to fulfill order');
    console.log('7. Doctor can also order lab tests');
    console.log('8. Login as Lab to process test requests\n');

  } catch (error) {
    console.error('❌ Seed Error:', error);
    throw error;
  }
};

// Run seed
const run = async () => {
  await connectDB();
  await seedData();
  console.log('🏁 Disconnecting from database...');
  await mongoose.disconnect();
  console.log('✅ Done!\n');
  process.exit(0);
};

run();
