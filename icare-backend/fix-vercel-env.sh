#!/bin/bash

# Fix Vercel Environment Variables
# Run this script to update environment variables on Vercel

echo "🔧 Fixing Vercel Environment Variables..."

# Set environment variables on Vercel
vercel env rm JWT_SECRET production -y 2>/dev/null
vercel env add JWT_SECRET production <<< "icare_jwt_secret_key_2026_production_secure_token_wajahat"

vercel env rm MONGO_URI production -y 2>/dev/null
vercel env add MONGO_URI production <<< "mongodb+srv://icaredev02_db_user:icaredev02@cluster0.kalraci.mongodb.net/icare_production"

vercel env rm NODE_ENV production -y 2>/dev/null
vercel env add NODE_ENV production <<< "production"

vercel env rm PORT production -y 2>/dev/null
vercel env add PORT production <<< "5000"

vercel env rm AGORA_APP_ID production -y 2>/dev/null
vercel env add AGORA_APP_ID production <<< "82a63a65663c49f0bb973707b4c09f5f"

vercel env rm AGORA_APP_CERTIFICATE production -y 2>/dev/null
vercel env add AGORA_APP_CERTIFICATE production <<< "cb6e19c098034597b1dab946861b95ce"

vercel env rm PUSHER_APP_ID production -y 2>/dev/null
vercel env add PUSHER_APP_ID production <<< "2125244"

vercel env rm PUSHER_KEY production -y 2>/dev/null
vercel env add PUSHER_KEY production <<< "f35e640cfef217a319dc"

vercel env rm PUSHER_SECRET production -y 2>/dev/null
vercel env add PUSHER_SECRET production <<< "af90c9b8f9ad63aae52c"

vercel env rm PUSHER_CLUSTER production -y 2>/dev/null
vercel env add PUSHER_CLUSTER production <<< "ap2"

echo "✅ Environment variables updated!"
echo "🚀 Now redeploy: vercel --prod"
