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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      phone: json['user']['phone'],
      token: json['token'],
      // Add nullable fields with null-aware operator
      gender: json['user']['gender'],
      age: json['user']['age'],
      bloodType: json['user']['bloodType'],
      weight: json['user']['weight']?.toDouble(),
      emergencyContacts: (json['user']['emergencyContacts'] as List?)
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

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      relation: json['relation'],
      number: json['number'],
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