import 'package:bloomix_mobile_app/models/plant.dart';
import 'package:bloomix_mobile_app/services/plant_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final plantServiceProvider = Provider<PlantService>((ref) {
  return PlantService();
});

final plantsProvider =
    StateNotifierProvider<PlantNotifier, AsyncValue<List<Plant>>>((ref) {
      return PlantNotifier(ref.read(plantServiceProvider));
    });

class PlantNotifier extends StateNotifier<AsyncValue<List<Plant>>> {
  PlantNotifier(this._plantService) : super(const AsyncValue.loading()) {
    loadPlants();
  }

  final PlantService _plantService;

  Future<void> loadPlants() async {
    try {
      state = const AsyncValue.loading();

      final plants = await _plantService.getPlants();

      state = AsyncValue.data(plants);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPlant({
    required String name,
    required int wateringFrequency,
    required DateTime lastWateredDate,
  }) async {
    await _plantService.addPlant(
      name: name,
      wateringFrequency: wateringFrequency,
      lastWateredDate: lastWateredDate,
    );

    await loadPlants();
  }

  Future<void> waterPlant(Plant plant) async {
    await _plantService.waterPlant(plant);

    await loadPlants();
  }
}
