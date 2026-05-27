import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String name;
  final int wateringFrequency;
  final DateTime lastWateredDate;

  const Plant({
    required this.id,
    required this.name,
    required this.wateringFrequency,
    required this.lastWateredDate,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      wateringFrequency: json['wateringFrequency'],
      lastWateredDate: (json['lastWateredDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'wateringFrequency': wateringFrequency,
      'lastWateredDate': Timestamp.fromDate(lastWateredDate),
    };
  }
}
