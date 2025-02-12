class Patient {
  final String id;
  final PersonalInfo personalInfo;
  final MedicalHistory medicalHistory;
  final FamilyHistory familyHistory;
  final Lifestyle lifestyle;
  final List<Symptom> currentSymptoms;
  final Immunizations immunizations;
  final MentalHealth mentalHealth;
  final EmergencyContact emergencyContact;
  final Insurance insurance;
  final Preferences preferences;

  Patient({
    required this.id,
    required this.personalInfo,
    required this.medicalHistory,
    required this.familyHistory,
    required this.lifestyle,
    required this.currentSymptoms,
    required this.immunizations,
    required this.mentalHealth,
    required this.emergencyContact,
    required this.insurance,
    required this.preferences,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      personalInfo: PersonalInfo.fromJson(json['personalInfo']),
      medicalHistory: MedicalHistory.fromJson(json['medicalHistory']),
      familyHistory: FamilyHistory.fromJson(json['familyHistory']),
      lifestyle: Lifestyle.fromJson(json['lifestyle']),
      currentSymptoms: (json['currentSymptoms'] as List)
          .map((symptom) => Symptom.fromJson(symptom))
          .toList(),
      immunizations: Immunizations.fromJson(json['immunizations']),
      mentalHealth: MentalHealth.fromJson(json['mentalHealth']),
      emergencyContact: EmergencyContact.fromJson(json['emergencyContact']),
      insurance: Insurance.fromJson(json['insurance']),
      preferences: Preferences.fromJson(json['preferences']),
    );
  }

  Map<String, dynamic> toJson() => {
    'personalInfo': personalInfo.toJson(),
    'medicalHistory': medicalHistory.toJson(),
    'familyHistory': familyHistory.toJson(),
    'lifestyle': lifestyle.toJson(),
    'currentSymptoms': currentSymptoms.map((s) => s.toJson()).toList(),
    'immunizations': immunizations.toJson(),
    'mentalHealth': mentalHealth.toJson(),
    'emergencyContact': emergencyContact.toJson(),
    'insurance': insurance.toJson(),
    'preferences': preferences.toJson(),
  };
}

class PersonalInfo {
  final String fullName;
  final String dateOfBirth;
  final String gender;

  PersonalInfo({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
  };
}

class MedicalHistory {
  final List<String> chronicConditions;
  final List<dynamic> pastSurgeries;
  final List<dynamic> currentMedications;
  final List<String> allergies;
  final List<String> hospitalVisits;
  final List<String> pastIllnesses;

  MedicalHistory({
    required this.chronicConditions,
    required this.pastSurgeries,
    required this.currentMedications,
    required this.allergies,
    required this.hospitalVisits,
    required this.pastIllnesses,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      chronicConditions: List<String>.from(json['chronicConditions'] ?? []),
      pastSurgeries: json['pastSurgeries'] ?? [],
      currentMedications: json['currentMedications'] ?? [],
      allergies: List<String>.from(json['allergies'] ?? []),
      hospitalVisits: List<String>.from(json['hospitalVisits'] ?? []),
      pastIllnesses: List<String>.from(json['pastIllnesses'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'chronicConditions': chronicConditions,
    'pastSurgeries': pastSurgeries,
    'currentMedications': currentMedications,
    'allergies': allergies,
    'hospitalVisits': hospitalVisits,
    'pastIllnesses': pastIllnesses,
  };
}

// Similarly define other classes (FamilyHistory, Lifestyle, Symptom, etc.)
class FamilyHistory {
  final List<String> conditions;
  final List<String> geneticDisorders;

  FamilyHistory({
    required this.conditions,
    required this.geneticDisorders,
  });

  factory FamilyHistory.fromJson(Map<String, dynamic> json) {
    return FamilyHistory(
      conditions: List<String>.from(json['conditions'] ?? []),
      geneticDisorders: List<String>.from(json['geneticDisorders'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'conditions': conditions,
    'geneticDisorders': geneticDisorders,
  };
}

class Lifestyle {
  final Map<String, dynamic> smoking;
  final Map<String, dynamic> alcohol;
  final Map<String, dynamic> drugs;
  final Map<String, dynamic> exercise;
  final String diet;
  final String stressLevel;
  final String sleepQuality;

  Lifestyle({
    required this.smoking,
    required this.alcohol,
    required this.drugs,
    required this.exercise,
    required this.diet,
    required this.stressLevel,
    required this.sleepQuality,
  });

  factory Lifestyle.fromJson(Map<String, dynamic> json) {
    return Lifestyle(
      smoking: json['smoking'] ?? {},
      alcohol: json['alcohol'] ?? {},
      drugs: json['drugs'] ?? {},
      exercise: json['exercise'] ?? {},
      diet: json['diet'] ?? '',
      stressLevel: json['stressLevel'] ?? '',
      sleepQuality: json['sleepQuality'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'smoking': smoking,
    'alcohol': alcohol,
    'drugs': drugs,
    'exercise': exercise,
    'diet': diet,
    'stressLevel': stressLevel,
    'sleepQuality': sleepQuality,
  };
}

class Symptom {
  final String description;
  final String startDate;
  final List<String> medications;
  final String progression;

  Symptom({
    required this.description,
    required this.startDate,
    required this.medications,
    required this.progression,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      medications: List<String>.from(json['medications'] ?? []),
      progression: json['progression'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'startDate': startDate,
    'medications': medications,
    'progression': progression,
  };
}
class Immunizations {
  final List<String> allergies;
  final List<dynamic> vaccines;
  final bool upToDate;

  Immunizations({
    required this.allergies,
    required this.vaccines,
    required this.upToDate,
  });

  factory Immunizations.fromJson(Map<String, dynamic> json) {
    return Immunizations(
      allergies: List<String>.from(json['allergies'] ?? []),
      vaccines: json['vaccines'] ?? [],
      upToDate: json['upToDate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'allergies': allergies,
    'vaccines': vaccines,
    'upToDate': upToDate,
  };
}

class MentalHealth {
  final String stressAnxiety;
  final String sleepIssues;
  final List<String> conditions;
  final bool seekingHelp;

  MentalHealth({
    required this.stressAnxiety,
    required this.sleepIssues,
    required this.conditions,
    required this.seekingHelp,
  });

  factory MentalHealth.fromJson(Map<String, dynamic> json) {
    return MentalHealth(
      stressAnxiety: json['stressAnxiety'] ?? '',
      sleepIssues: json['sleepIssues'] ?? '',
      conditions: List<String>.from(json['conditions'] ?? []),
      seekingHelp: json['seekingHelp'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'stressAnxiety': stressAnxiety,
    'sleepIssues': sleepIssues,
    'conditions': conditions,
    'seekingHelp': seekingHelp,
  };
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'relationship': relationship,
    'phone': phone,
  };
}

class Preferences {
  final bool dataConsent;
  final bool healthReminders;
  final String preferredCommunication;

  Preferences({
    required this.dataConsent,
    required this.healthReminders,
    required this.preferredCommunication,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      dataConsent: json['dataConsent'] ?? false,
      healthReminders: json['healthReminders'] ?? false,
      preferredCommunication: json['preferredCommunication'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'dataConsent': dataConsent,
    'healthReminders': healthReminders,
    'preferredCommunication': preferredCommunication,
  };
}
class Insurance {
  final bool hasInsurance;
  final String provider;
  final String policyNumber;

  Insurance({
    required this.hasInsurance,
    required this.provider,
    required this.policyNumber,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      hasInsurance: json['hasInsurance'] ?? false,
      provider: json['provider'] ?? '',
      policyNumber: json['policyNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'hasInsurance': hasInsurance,
    'provider': provider,
    'policyNumber': policyNumber,
  };
}