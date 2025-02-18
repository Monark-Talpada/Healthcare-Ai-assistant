const express = require('express');
const router = express.Router();
const Medicine = require('../models/Medicine');
const { protect } = require('../middleware/auth');

router.use(protect);

// Get all medicines
router.get('/', async (req, res) => {
  try {
    const medicines = await Medicine.find({ user: req.user._id }).sort({ createdAt: -1 });
    res.json(medicines);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Add new medicine
router.post('/', async (req, res) => {
  try {
    const medicine = new Medicine({
      user: req.user._id, // Add user reference
      name: req.body.name,
      dosesPerDay: req.body.dosesPerDay,
      quantity: req.body.quantity,
      remainingDoses: req.body.quantity,
      timings: req.body.timings,
      notifyLowStock: req.body.notifyLowStock,
      lowStockThreshold: req.body.lowStockThreshold
    });

    const newMedicine = await medicine.save();
    res.status(201).json(newMedicine);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update medicine
router.patch('/:id', async (req, res) => {
  try {
    const medicine = await Medicine.findOne({ _id: req.params.id, user: req.user._id });
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }
    // ... rest of the update logic
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});


// Delete medicine
router.delete('/:id', async (req, res) => {
  try {
    const medicine = await Medicine.findOne({ _id: req.params.id, user: req.user._id });
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }
    await medicine.deleteOne();
    res.json({ message: 'Medicine deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Take dose
router.post('/:id/take-dose', async (req, res) => {
  try {
    const medicine = await Medicine.findOne({ _id: req.params.id, user: req.user._id });
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }
    // ... rest of the take-dose logic
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});
router.post('/:id/take-dose', async (req, res) => {
  try {
    const medicine = await Medicine.findById(req.params.id);
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }

    const today = new Date().toISOString().split('T')[0];

    if (!medicine.takenToday) medicine.takenToday = {};
    if (!medicine.takenToday[today]) medicine.takenToday[today] = 0;

    if (medicine.takenToday[today] >= medicine.dosesPerDay) {
      return res.status(400).json({ message: 'You have already taken all doses today.' });
    }

    medicine.remainingDoses -= 1;
    medicine.takenToday[today] += 1;
    const updatedMedicine = await medicine.save();

    if (medicine.remainingDoses <= medicine.lowStockThreshold) {
      res.json({
        medicine: updatedMedicine,
        alert: {
          type: 'low_stock',
          message: `${medicine.name} is running low. Only ${medicine.remainingDoses} doses remaining.`,
        },
      });
    } else {
      res.json({ medicine: updatedMedicine });
    }
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});



module.exports = router;
