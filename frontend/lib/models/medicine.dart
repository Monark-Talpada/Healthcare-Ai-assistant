class Medicine {
  String? id;
  String name;
  List<Timing> timings;
  int dosesPerDay;
  int quantity;
  int remainingDoses;
  int takenToday;
  bool notifyLowStock;
  int lowStockThreshold;

  Medicine({
    this.id,
    required this.name,
    required this.timings,
    required this.dosesPerDay,
    required this.quantity,
    required this.remainingDoses,
    this.takenToday = 0,
    this.notifyLowStock = true,
    this.lowStockThreshold = 5,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'],
      name: json['name'],
      timings: (json['timings'] as List<dynamic>)
          .map((timing) => Timing.fromJson(timing))
          .toList(),
      dosesPerDay: json['dosesPerDay'],
      quantity: json['quantity'],
      remainingDoses: json['remainingDoses'],
      takenToday: json['takenToday'] ?? 0,
      notifyLowStock: json['notifyLowStock'],
      lowStockThreshold: json['lowStockThreshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timings': timings.map((timing) => timing.toJson()).toList(),
      'dosesPerDay': dosesPerDay,
      'quantity': quantity,
      'remainingDoses': remainingDoses,
      'takenToday': takenToday,
      'notifyLowStock': notifyLowStock,
      'lowStockThreshold': lowStockThreshold,
    };
  }
}

class Timing {
  int hour;
  int minute;

  Timing({required this.hour, required this.minute});

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }

  String format() {
    final hour12 = hour > 12 ? hour - 12 : hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}
