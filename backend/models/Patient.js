const mongoose = require('mongoose');

const PatientSchema = new mongoose.Schema({
  personalInfo: {
    fullName: { type: String, required: true },
    dateOfBirth: { type: String },
    gender: { type: String },
    bloodType: { type: String },
    height: { type: String },
    weight: { type: String },
    primaryLanguage: { type: String },
    contactInfo: {
      email: { type: String },
      phone: { type: String }
    }
  },
  medicalHistory: {
    chronicConditions: [String],
    pastSurgeries: [mongoose.Schema.Types.Mixed],
    currentMedications: [mongoose.Schema.Types.Mixed],
    allergies: [String],
    hospitalVisits: [String],
    pastIllnesses: [String]
  },
  familyHistory: {
    conditions: [String],
    geneticDisorders: [String]
  },
  lifestyle: {
    smoking: mongoose.Schema.Types.Mixed,
    alcohol: mongoose.Schema.Types.Mixed,
    drugs: mongoose.Schema.Types.Mixed,
    exercise: mongoose.Schema.Types.Mixed,
    diet: { type: String },
    stressLevel: { type: String },
    sleepQuality: { type: String }
  },
  currentSymptoms: [{
    description: { type: String },
    startDate: { type: String },
    medications: [String],
    progression: { type: String }
  }],
  immunizations: {
    allergies: [String],
    vaccines: [mongoose.Schema.Types.Mixed],
    upToDate: { type: Boolean, default: false }
  },
  mentalHealth: {
    stressAnxiety: { type: String },
    sleepIssues: { type: String },
    conditions: [String],
    seekingHelp: { type: Boolean, default: false }
  },
  emergencyContact: {
    name: { type: String },
    relationship: { type: String },
    phone: { type: String }
  },
  insurance: {
    hasInsurance: { type: Boolean, default: false },
    provider: { type: String },
    policyNumber: { type: String }
  },
  preferences: {
    dataConsent: { type: Boolean, default: false },
    healthReminders: { type: Boolean, default: false },
    preferredCommunication: { type: String }
  }
}, { timestamps: true });

module.exports = mongoose.model('PatientHistory', PatientSchema);