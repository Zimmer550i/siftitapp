import 'package:sarkasm/models/scan_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? imageUrl;
  List<ScanModel>? recentScans;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.imageUrl,
    this.recentScans,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'recentScans': recentScans?.map((scan) => scan.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create UserModel from Firestore JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'],
      recentScans: (json['recentScans'] as List<dynamic>?)
              ?.map((scan) => ScanModel.fromJson(scan as Map<String, dynamic>))
              .toList(),
      createdAt: (json['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as dynamic)?.toDate(),
    );
  }
}
