import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/patient_model.dart';

class PatientHistoryScreen extends StatefulWidget {
  final String? patientId;
  
  const PatientHistoryScreen({Key? key, this.patientId}) : super(key: key);

  @override
  _PatientHistoryScreenState createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientService _patientService = PatientService();
  bool _isLoading = false;
  
  // Personal Info Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Medical History Controllers
  final TextEditingController _chronicConditionsController = TextEditingController();
  final TextEditingController _pastSurgeriesController = TextEditingController();
  final TextEditingController _currentMedicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _hospitalVisitsController = TextEditingController();
  final TextEditingController _pastIllnessesController = TextEditingController();

  // Family History Controllers
  final TextEditingController _familyHistoryController = TextEditingController();
  final TextEditingController _geneticDisordersController = TextEditingController();

  // Lifestyle Controllers
  final TextEditingController _smokingController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _drugsController = TextEditingController();
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _stressController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();

  // Symptoms Controllers
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _symptomStartController = TextEditingController();
  final TextEditingController _medicationForSymptomsController = TextEditingController();
  final TextEditingController _symptomChangeController = TextEditingController();

  // Other Controllers
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
  void initState() {
    super.initState();
    if (widget.patientId != null) {
      _loadPatientData();
    }
  }

  Future<void> _loadPatientData() async {
    setState(() => _isLoading = true);
    try {
      final patientData = await _patientService.getPatient(widget.patientId!);
      _populateFields(patientData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading patient data: $e'))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateFields(Map<String, dynamic> patientData) {
    final personalInfo = patientData['personalInfo'] ?? {};
    _nameController.text = personalInfo['fullName'] ?? '';
    _dobController.text = personalInfo['dateOfBirth'] ?? '';
    _genderController.text = personalInfo['gender'] ?? '';
    _bloodTypeController.text = personalInfo['bloodType'] ?? '';
    _heightController.text = personalInfo['height'] ?? '';
    _weightController.text = personalInfo['weight'] ?? '';
    _languageController.text = personalInfo['primaryLanguage'] ?? '';
    
    final contactInfo = personalInfo['contactInfo'] ?? {};
    _emailController.text = contactInfo['email'] ?? '';
    _phoneController.text = contactInfo['phone'] ?? '';
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[0-9]{10,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _submitPatientHistory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final patientData = {
        'personalInfo': {
          'fullName': _nameController.text,
          'dateOfBirth': _dobController.text,
          'gender': _genderController.text,
          'bloodType': _bloodTypeController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'primaryLanguage': _languageController.text,
          'contactInfo': {
            'email': _emailController.text,
            'phone': _phoneController.text,
          }
        },
        'medicalHistory': {
          'chronicConditions': _chronicConditionsController.text.isNotEmpty 
            ? _chronicConditionsController.text.split(',') 
            : [],
          'pastSurgeries': _pastSurgeriesController.text.isNotEmpty
            ? _pastSurgeriesController.text.split('\n').map((surgery) => {
                'procedure': surgery.contains(' - ') ? surgery.split(' - ')[0] : surgery,
                'date': surgery.contains(' - ') ? surgery.split(' - ')[1] : '',
              }).toList()
            : [],
          'currentMedications': _currentMedicationsController.text.isNotEmpty
            ? _currentMedicationsController.text.split('\n').map((med) => {
                'name': med.contains(' - ') ? med.split(' - ')[0] : med,
                'dosage': med.contains(' - ') ? med.split(' - ')[1] : '',
              }).toList()
            : [],
          'allergies': _allergiesController.text.isNotEmpty 
            ? _allergiesController.text.split(',') 
            : [],
          'hospitalVisits': _hospitalVisitsController.text.isNotEmpty 
            ? _hospitalVisitsController.text.split('\n') 
            : [],
          'pastIllnesses': _pastIllnessesController.text.isNotEmpty 
            ? _pastIllnessesController.text.split(',') 
            : []
        },
        'familyHistory': {
          'conditions': _familyHistoryController.text.isNotEmpty 
            ? _familyHistoryController.text.split(',') 
            : [],
          'geneticDisorders': _geneticDisordersController.text.isNotEmpty 
            ? _geneticDisordersController.text.split(',') 
            : []
        },
        'lifestyle': {
          'smoking': {'status': _smokingController.text},
          'alcohol': {'status': _alcoholController.text},
          'drugs': {'status': _drugsController.text},
          'exercise': {'frequency': _exerciseController.text},
          'diet': _dietController.text,
          'stressLevel': _stressController.text,
          'sleepQuality': _sleepController.text
        },
        'currentSymptoms': [{
          'description': _symptomsController.text,
          'startDate': _symptomStartController.text,
          'medications': _medicationForSymptomsController.text.isNotEmpty 
            ? _medicationForSymptomsController.text.split(',') 
            : [],
          'progression': _symptomChangeController.text
        }],
        'immunizations': {
          'allergies': _allergiesListController.text.isNotEmpty 
            ? _allergiesListController.text.split(',') 
            : [],
          'vaccines': _vaccinesController.text.isNotEmpty
            ? _vaccinesController.text.split('\n').map((vaccine) => {
                'name': vaccine.contains(' - ') ? vaccine.split(' - ')[0] : vaccine,
                'date': vaccine.contains(' - ') ? vaccine.split(' - ')[1] : '',
              }).toList()
            : [],
          'upToDate': _vaccinationsUpToDateController.text == 'Yes'
        },
        'mentalHealth': {
          'stressAnxiety': _stressAnxietyController.text,
          'sleepIssues': _sleepIssuesController.text,
          'conditions': _mentalHealthConditionsController.text.isNotEmpty 
            ? _mentalHealthConditionsController.text.split(',') 
            : [],
          'seekingHelp': _mentalHealthHelpController.text == 'Yes'
        },
        'emergencyContact': {
          'name': _emergencyContactNameController.text,
          'relationship': _emergencyContactRelationshipController.text,
          'phone': _emergencyContactPhoneController.text
        },
        'insurance': {
          'hasInsurance': _hasInsuranceController.text == 'Yes',
          'provider': _insuranceProviderController.text,
          'policyNumber': _insurancePolicyNumberController.text
        },
        'preferences': {
          'dataConsent': _dataConsentController.text == 'Yes',
          'healthReminders': _healthRemindersController.text == 'Yes',
          'preferredCommunication': _preferredCommunicationController.text
        }
      };

      final response = widget.patientId == null
        ? await _patientService.createPatient(patientData)
        : await _patientService.updatePatient(widget.patientId!, patientData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient data saved successfully'))
      );
      
      Navigator.pop(context, response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving patient data: $e'))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Patient History')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient History'),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Personal Information', [
                _buildValidatedField(
                  'Full Name', 
                  _nameController, 
                  validator: _validateName
                ),
                _buildField('Date of Birth', _dobController),
                _buildField('Gender', _genderController),
                _buildField('Blood Type', _bloodTypeController),
                _buildField('Height', _heightController),
                _buildField('Weight', _weightController),
                _buildField('Primary Language', _languageController),
                _buildValidatedField(
                  'Email', 
                  _emailController, 
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress
                ),
                _buildValidatedField(
                  'Phone Number', 
                  _phoneController, 
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone
                ),
              ]),
              // Add other sections similarly
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: _submitPatientHistory,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedField(
    String label, 
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            errorStyle: TextStyle(color: Colors.red),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...fields,
        SizedBox(height: 16),
      ],
    );
  }

  // Widget _buildField(String label, TextEditingController controller) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: 8),
  //       TextField(
  //         controller: controller,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //     ],
  //   );
  // }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _dobController.dispose();
    // ... dispose other controllers
    super.dispose();
  }
}