const mongoose = require('mongoose');

const profileSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  gender: String,
  age: Number,
  bloodType: String,
  weight: Number,
  emergencyContacts: [{
    relation: {
      type: String,
      required: true
    },
    number: {
      type: String,
      required: true
    }
  }]
});

const Profile = mongoose.model('Profile', profileSchema);
module.exports = Profile;