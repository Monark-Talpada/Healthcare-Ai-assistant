const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');
const { 
    getProfile, 
    updateProfile 
} = require('../controllers/profileController');

// Add these routes
router.get('/profile', protect, getProfile);
router.put('/profile', protect, updateProfile);

module.exports = router;