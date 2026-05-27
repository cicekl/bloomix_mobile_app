import 'package:bloomix_mobile_app/models/plant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlantService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _plantsCollection() {
    final userId = _auth.currentUser!.uid;

    return _firestore.collection('users').doc(userId).collection('plants');
  }

  Future<void> addPlant({
    required String name,
    required int wateringFrequency,
    required DateTime lastWateredDate,
  }) async {
    final doc = _plantsCollection().doc();

    final plant = Plant(
      id: doc.id,
      name: name,
      wateringFrequency: wateringFrequency,
      lastWateredDate: lastWateredDate,
    );

    await doc.set(plant.toJson());
  }

  Future<List<Plant>> getPlants() async {
    final snapshot = await _plantsCollection().get();

    return snapshot.docs.map((doc) {
      return Plant.fromJson(doc.data());
    }).toList();
  }

  Future<void> waterPlant(Plant plant) async {
    await _plantsCollection().doc(plant.id).update({
      'lastWateredDate': Timestamp.fromDate(DateTime.now()),
    });
  }
}
