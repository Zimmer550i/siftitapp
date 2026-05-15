class ScanModel {
  final String name;
  final String id;
  final double safety;
  List<IngrediantModel> ingrediants;
  final DateTime createdAt;
  final DateTime modifiedAt;

  ScanModel({
    required this.name,
    required this.id,
    required this.safety,
    required this.ingrediants,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    return ScanModel(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      safety: (json['safety'] ?? 0).toDouble(),
      ingrediants: (json['ingrediants'] as List<dynamic>? ?? [])
          .map((e) => IngrediantModel.fromJson(e))
          .toList(),
      createdAt: _dateTimeFromJson(json['createdAt']),
      modifiedAt: _dateTimeFromJson(json['modifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'safety': safety,
      'ingrediants': ingrediants.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  ScanModel copyWith({
    String? name,
    String? id,
    double? safety,
    List<IngrediantModel>? ingrediants,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return ScanModel(
      name: name ?? this.name,
      id: id ?? this.id,
      safety: safety ?? this.safety,
      ingrediants: ingrediants ?? this.ingrediants,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }
}

class IngrediantModel {
  final String name;
  final String id;
  final Impact impact;
  final String reason;

  IngrediantModel({
    required this.name,
    required this.id,
    required this.impact,
    required this.reason,
  });

  factory IngrediantModel.fromJson(Map<String, dynamic> json) {
    return IngrediantModel(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      impact: impactFromString(json['impact'] ?? ''),
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'impact': impactToString(impact),
      'reason': reason,
    };
  }

  IngrediantModel copyWith({
    String? name,
    String? id,
    Impact? impact,
    String? reason,
  }) {
    return IngrediantModel(
      name: name ?? this.name,
      id: id ?? this.id,
      impact: impact ?? this.impact,
      reason: reason ?? this.reason,
    );
  }
}

enum Impact { high, med, low }

Impact impactFromString(String value) {
  value = value.toLowerCase();
  switch (value.toLowerCase()) {
    case 'high':
      return Impact.high;
    case 'med':
    case 'medium':
      return Impact.med;
    case 'low':
      return Impact.low;
    default:
      return Impact.low;
  }
}

String impactToString(Impact impact) {
  switch (impact) {
    case Impact.high:
      return 'High';
    case Impact.med:
      return 'Med';
    case Impact.low:
      return 'Low';
  }
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value == null) return DateTime.now();

  if (value is DateTime) return value;

  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  final dynamic seconds = value.seconds;
  final dynamic nanoseconds = value.nanoseconds;

  if (seconds is int) {
    final milliseconds =
        seconds * 1000 + ((nanoseconds is int ? nanoseconds : 0) ~/ 1000000);
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  return DateTime.now();
}
