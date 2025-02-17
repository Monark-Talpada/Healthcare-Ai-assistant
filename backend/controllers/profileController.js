const Profile = require('../models/Profile');
const User = require('../models/User');

exports.getProfile = async (req, res) => {
  try {
    let profile = await Profile.findOne({ user: req.user.id });
    
    if (!profile) {
      profile = await Profile.create({
        user: req.user.id
      });
    }

    const user = await User.findById(req.user.id);

    res.status(200).json({
      success: true,
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        gender: profile.gender,
        age: profile.age,
        bloodType: profile.bloodType,
        weight: profile.weight,
        emergencyContacts: profile.emergencyContacts
      }
    });
  } catch (error) {
    console.error('Profile fetch error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const { name, phone, gender, age, bloodType, weight, emergencyContacts } = req.body;
    console.log('Update request body:', req.body); // Debug log

    // Update user details
    const user = await User.findByIdAndUpdate(
      req.user.id,
      { name, phone },
      { new: true }
    );

    // Find or create profile
    let profile = await Profile.findOne({ user: req.user.id });
    if (!profile) {
      profile = await Profile.create({
        user: req.user.id,
        gender,
        age,
        bloodType,
        weight,
        emergencyContacts
      });
    } else {
      profile = await Profile.findOneAndUpdate(
        { user: req.user.id },
        { gender, age, bloodType, weight, emergencyContacts },
        { new: true }
      );
    }

    res.status(200).json({
      success: true,
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        gender: profile.gender,
        age: profile.age,
        bloodType: profile.bloodType,
        weight: profile.weight,
        emergencyContacts: profile.emergencyContacts
      }
    });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'Error updating profile'
    });
  }
};