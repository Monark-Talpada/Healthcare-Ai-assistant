const User = require('../models/User');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Configure multer for file upload
const uploadDir = './public/uploads/profile';
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Configure multer for file upload
const storage = multer.diskStorage({
  destination: function(req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function(req, file, cb) {
    // Generate unique filename using userId and timestamp
    const uniqueSuffix = `${req.user._id}-${Date.now()}${path.extname(file.originalname)}`;
    cb(null, uniqueSuffix);
  }
});

// File filter function
const fileFilter = (req, file, cb) => {
  // Accept only jpeg, jpg, and png
  if (file.mimetype.startsWith('image/')) {
    const allowedTypes = ['jpeg', 'jpg', 'png'];
    const fileType = file.mimetype.split('/')[1];
    if (allowedTypes.includes(fileType)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Only JPEG, JPG and PNG files are allowed.'), false);
    }
  } else {
    cb(new Error('Invalid file type. Only images are allowed.'), false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: fileFilter
});

// Check file type
// function checkFileType(file, cb) {
//   const filetypes = /jpeg|jpg|png/;
//   const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
//   const mimetype = filetypes.test(file.mimetype);

//   if (mimetype && extname) {
//     return cb(null, true);
//   } else {
//     cb('Error: Images only!');
//   }
// }

// Get user profile
exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-password');
    res.status(200).json({
      success: true,
      data: user
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Update profile
exports.updateProfile = async (req, res) => {
  try {
    const updateData = {
      name: req.body.name,
      phone: req.body.phone,
      gender: req.body.gender,
      age: req.body.age,
      bloodType: req.body.bloodType,
      weight: req.body.weight
    };

    const user = await User.findByIdAndUpdate(
      req.user._id,
      { $set: updateData },
      { new: true, runValidators: true }
    ).select('-password');

    res.status(200).json({
      success: true,
      data: user
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Upload profile photo
exports.uploadProfilePhoto = async (req, res) => {
  try {
    // Use multer upload as middleware
    upload.single('profilePhoto')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({
          success: false,
          message: err.message
        });
      }

      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: 'Please upload a file'
        });
      }

      try {
        // Get current user
        const user = await User.findById(req.user._id);

        // Delete old profile photo if it exists
        if (user.profilePhoto) {
          const oldPhotoPath = path.join(__dirname, '..', 'public', user.profilePhoto);
          if (fs.existsSync(oldPhotoPath)) {
            fs.unlinkSync(oldPhotoPath);
          }
        }

        // Update user with new photo path
        const photoUrl = `/uploads/profile/${req.file.filename}`;

        const updatedUser = await User.findByIdAndUpdate(
          req.user._id,
          { profilePhoto: photoUrl },
          { new: true }
        ).select('-password');

        res.status(200).json({
          success: true,
          data: updatedUser
        });
      } catch (error) {
        // Delete uploaded file if database update fails
        if (req.file) {
          fs.unlinkSync(req.file.path);
        }
        throw error;
      }
    });
  } catch (error) {
    console.error('Profile photo upload error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};


exports.getProfilePhoto = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    if (!user.profilePhoto) {
      return res.status(404).json({
        success: false,
        message: 'No profile photo found'
      });
    }

    const photoPath = path.join(__dirname, '..', 'public', user.profilePhoto);
    if (!fs.existsSync(photoPath)) {
      return res.status(404).json({
        success: false,
        message: 'Profile photo file not found'
      });
    }

    res.sendFile(photoPath);
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};