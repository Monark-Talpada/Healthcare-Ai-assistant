class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;
  final String? gender;
  final int? age;
  final String? bloodType;
  final double? weight;
  final List<EmergencyContact> emergencyContacts;
  final String? profilePhoto;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    this.gender,
    this.age,
    this.bloodType,
    this.weight,
    this.emergencyContacts = const [],
    this.profilePhoto,
  });

factory User.fromJson(Map<String, dynamic> json) {
    // Handle both cases: when data is nested under 'user' and when it's not
    final userData = json['user'] ?? json['data'] ?? json;
    return User(
      id: userData['id'] ?? userData['_id'], // Handle both id formats
      name: userData['name'],
      email: userData['email'],
      phone: userData['phone'],
      token: json['token'], // Token is at the root level
      gender: userData['gender'],
      age: userData['age'],
      bloodType: userData['bloodType'],
      profilePhoto: userData['profilePhoto'],
      weight: userData['weight']?.toDouble(),
      emergencyContacts: (userData['emergencyContacts'] as List?)
          ?.map((e) => EmergencyContact.fromJson(e))
          .toList() ?? [],

    );
}
  // Add copyWith method to create a new instance with updated fields
  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? gender,
    int? age,
    String? bloodType,
    String? profilePhoto,
    double? weight,
    List<EmergencyContact>? emergencyContacts,
  }) {
    return User(
      id: id,
      token: token, // Keep the original token
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      weight: weight ?? this.weight,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    );
  }

  // Add toJson method for sending updates to the server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'age': age,
      'bloodType': bloodType,
      'profilePhoto': profilePhoto,
      'weight': weight,
      'emergencyContacts': emergencyContacts.map((e) => e.toJson()).toList(),
    };
  }
}

class EmergencyContact {
  final String id;
  final String relation;
  final String number;

  EmergencyContact({
    required this.id,
    required this.relation,
    required this.number,
  });

// In user_model.dart
factory EmergencyContact.fromJson(Map<String, dynamic> json) {
  return EmergencyContact(
    id: json['_id'] ?? json['id'] ?? '', // Provide default empty string if both are null
    relation: json['relation'] ?? '',     // Provide default empty string if null
    number: json['number'] ?? '',         // Provide default empty string if null
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relation': relation,
      'number': number,
    };
  }

  EmergencyContact copyWith({
    String? relation,
    String? number,
  }) {
    return EmergencyContact(
      id: id,
      relation: relation ?? this.relation,
      number: number ?? this.number,
    );
  }
}