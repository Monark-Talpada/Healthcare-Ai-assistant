const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');
const User = require('../models/User');
const multer = require('multer');
const path = require('path');
const fs = require('fs');


const {
  getProfile,
  updateProfile,
  uploadProfilePhoto
} = require('../controllers/profileController');

router.get('/profile', protect, getProfile);
router.put('/profile', protect, updateProfile);
router.post('/profile/photo/:filename', protect, uploadProfilePhoto);

router.post('/emergency-contacts', protect, async (req, res) => {
    try {
      const user = await User.findById(req.user._id);
      
      const newContact = {
        relation: req.body.relation,
        number: req.body.number
      };

      user.emergencyContacts.push(newContact);
      await user.save();
  
      res.status(201).json({
        success: true,
        data: user.emergencyContacts[user.emergencyContacts.length - 1]
      });
    } catch (error) {
        console.error('Add contact error:', error);
      res.status(500).json({
        success: false,
        message: 'Server error',
        error: error.message
      });
    }
  });
  
  router.delete('/emergency-contacts/:id', protect, async (req, res) => {
    try {
      const user = await User.findById(req.user._id);
      
      user.emergencyContacts = user.emergencyContacts.filter(
        contact => contact._id.toString() !== req.params.id
      );
  
      await user.save();
  
      res.status(200).json({
        success: true,
        message: 'Contact deleted successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Server error',
        error: error.message
      });
    }
  });

 
module.exports = router;