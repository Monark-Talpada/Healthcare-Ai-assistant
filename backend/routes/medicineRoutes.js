const express = require('express');
const router = express.Router();
const Medicine = require('../models/Medicine');

// Get all medicines
router.get('/', async (req, res) => {
  try {
    const medicines = await Medicine.find().sort({ createdAt: -1 });
    res.json(medicines);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Add new medicine
router.post('/', async (req, res) => {
  try {
    const medicine = new Medicine({
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
    const medicine = await Medicine.findById(req.params.id);
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }

    if (req.body.name) medicine.name = req.body.name;
    if (req.body.dosesPerDay) medicine.dosesPerDay = req.body.dosesPerDay;
    if (req.body.quantity) {
      medicine.quantity = req.body.quantity;
      medicine.remainingDoses = req.body.quantity;
    }
    if (req.body.timings) medicine.timings = req.body.timings;
    if (req.body.notifyLowStock !== undefined) medicine.notifyLowStock = req.body.notifyLowStock;
    if (req.body.lowStockThreshold) medicine.lowStockThreshold = req.body.lowStockThreshold;

    const updatedMedicine = await medicine.save();
    res.json(updatedMedicine);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete medicine
router.delete('/:id', async (req, res) => {
  try {
    const medicine = await Medicine.findById(req.params.id);
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
    const medicine = await Medicine.findById(req.params.id);
    if (!medicine) {
      return res.status(404).json({ message: 'Medicine not found' });
    }

    if (medicine.remainingDoses <= 0) {
      return res.status(400).json({ message: 'No doses remaining' });
    }

    medicine.remainingDoses -= 1;
    const updatedMedicine = await medicine.save();
    
    // Check if medicine is running low
    if (medicine.notifyLowStock && medicine.remainingDoses <= medicine.lowStockThreshold) {
      res.json({
        medicine: updatedMedicine,
        alert: {
          type: 'low_stock',
          message: `${medicine.name} is running low. Only ${medicine.remainingDoses} doses remaining.`
        }
      });
    } else {
      res.json({ medicine: updatedMedicine });
    }
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
