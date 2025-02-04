import 'package:flutter/material.dart';

class PatientHistoryScreen extends StatefulWidget {
  const PatientHistoryScreen({Key? key}) : super(key: key);

  @override
  _PatientHistoryScreenState createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _heightWeightController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  final TextEditingController _chronicConditionsController = TextEditingController();
  final TextEditingController _pastSurgeriesController = TextEditingController();
  final TextEditingController _currentMedicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _hospitalVisitsController = TextEditingController();
  final TextEditingController _pastIllnessesController = TextEditingController();

  final TextEditingController _familyHistoryController = TextEditingController();
  final TextEditingController _geneticDisordersController = TextEditingController();

  final TextEditingController _smokingController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _drugsController = TextEditingController();
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _stressController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();

  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _symptomStartController = TextEditingController();
  final TextEditingController _medicationForSymptomsController = TextEditingController();
  final TextEditingController _symptomChangeController = TextEditingController();

  final TextEditingController _allergiesListController = TextEditingController();
  final TextEditingController _vaccinesController = TextEditingController();
  final TextEditingController _vaccinationsUpToDateController = TextEditingController();

  final TextEditingController _stressAnxietyController = TextEditingController();
  final TextEditingController _sleepIssuesController = TextEditingController();
  final TextEditingController _mentalHealthConditionsController = TextEditingController();
  final TextEditingController _mentalHealthHelpController = TextEditingController();

  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactRelationshipController = TextEditingController();
  final TextEditingController _emergencyContactPhoneController = TextEditingController();

  final TextEditingController _hasInsuranceController = TextEditingController();
  final TextEditingController _insuranceProviderController = TextEditingController();
  final TextEditingController _insurancePolicyNumberController = TextEditingController();

  final TextEditingController _dataConsentController = TextEditingController();
  final TextEditingController _healthRemindersController = TextEditingController();
  final TextEditingController _preferredCommunicationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient History'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information
            _buildSection('Personal Information', [
              _buildField('Full Name', _nameController),
              _buildField('Date of Birth', _dobController),
              _buildField('Gender', _genderController),
              _buildField('Blood Type', _bloodTypeController),
              _buildField('Height and Weight', _heightWeightController),
              _buildField('Primary Language', _languageController),
              _buildField('Contact Information', _contactController),
            ]),

            // Medical History
            _buildSection('Medical History', [
              _buildField('Chronic Conditions', _chronicConditionsController),
              _buildField('Past Surgeries', _pastSurgeriesController),
              _buildField('Current Medications', _currentMedicationsController),
              _buildField('Allergies', _allergiesController),
              _buildField('Past Hospitalizations', _hospitalVisitsController),
              _buildField('Past Illnesses', _pastIllnessesController),
            ]),

            // Family Medical History
            _buildSection('Family Medical History', [
              _buildField('Family Health History', _familyHistoryController),
              _buildField('Genetic Disorders', _geneticDisordersController),
            ]),

            // Lifestyle and Habits
            _buildSection('Lifestyle and Habits', [
              _buildField('Smoking/Tobacco Use', _smokingController),
              _buildField('Alcohol Consumption', _alcoholController),
              _buildField('Recreational Drug Use', _drugsController),
              _buildField('Exercise Frequency', _exerciseController),
              _buildField('Diet', _dietController),
              _buildField('Stress Levels', _stressController),
              _buildField('Sleep Quality', _sleepController),
            ]),

            // Symptoms and Current Complaints
            _buildSection('Symptoms and Current Complaints', [
              _buildField('Symptoms', _symptomsController),
              _buildField('Symptom Start Date', _symptomStartController),
              _buildField('Medications for Symptoms', _medicationForSymptomsController),
              _buildField('Symptom Change', _symptomChangeController),
            ]),

            // Allergies and Immunizations
            _buildSection('Allergies and Immunizations', [
              _buildField('Allergies', _allergiesListController),
              _buildField('Vaccines Received', _vaccinesController),
              _buildField('Vaccinations Up-to-Date', _vaccinationsUpToDateController),
            ]),

            // Mental Health
            _buildSection('Mental Health', [
              _buildField('Stress and Anxiety', _stressAnxietyController),
              _buildField('Sleep Issues', _sleepIssuesController),
              _buildField('Mental Health Conditions', _mentalHealthConditionsController),
              _buildField('Mental Health Help', _mentalHealthHelpController),
            ]),

            // Emergency Contact
            _buildSection('Emergency Contact', [
              _buildField('Name', _emergencyContactNameController),
              _buildField('Relationship', _emergencyContactRelationshipController),
              _buildField('Phone Number', _emergencyContactPhoneController),
            ]),

            // Insurance Information
            _buildSection('Insurance Information', [
              _buildField('Have Insurance', _hasInsuranceController),
              _buildField('Insurance Provider', _insuranceProviderController),
              _buildField('Policy Number', _insurancePolicyNumberController),
            ]),

            // Consent and Preferences
            _buildSection('Consent and Preferences', [
              _buildField('Data Consent', _dataConsentController),
              _buildField('Health Reminders', _healthRemindersController),
              _buildField('Preferred Communication', _preferredCommunicationController),
            ]),

            ElevatedButton(
              onPressed: _submitPatientHistory,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...fields,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitPatientHistory() {
    // Implement logic to save the patient history data
    // You can add validation, error handling, and submission logic here
    print('Patient history submitted');
  }
}