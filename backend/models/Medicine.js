const mongoose = require('mongoose');

const medicineSchema = new mongoose.Schema({

  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  name: {
    type: String,
    required: true
  },

  dosesPerDay: {
    type: Number,
    required: true
  },
  quantity: {
    type: Number,
    required: true
  },
  remainingDoses: {
    type: Number,
    required: true
  },
  timings: [{
    hour: {
      type: Number,
      required: true
    },
    minute: {
      type: Number,
      required: true
    }
  }],
  notifyLowStock: {
    type: Boolean,
    default: true
  },
  lowStockThreshold: {
    type: Number,
    default: 5
  }
}, {
  timestamps: true
});

const Medicine = mongoose.model('MedicineTracking', medicineSchema);
module.exports = Medicine;
