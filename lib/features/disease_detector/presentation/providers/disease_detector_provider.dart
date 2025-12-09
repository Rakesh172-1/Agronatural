import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/disease_detector/data/models/crop_disease_model.dart';
import 'package:vriddhiapps/features/disease_detector/data/services/disease_detector_service.dart';

final diseaseDetectorServiceProvider = Provider((ref) => DiseaseDetectorService());

class DiseaseDetectorNotifier extends StateNotifier<AsyncValue<List<CropDisease>>> {
  final DiseaseDetectorService _service;

  DiseaseDetectorNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> fetchAllDiseases() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getAllDiseases());
  }

  Future<void> fetchDiseasesByCrop(String cropType) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getDiseasesByCrop(cropType));
  }

  Future<void> searchDiseases(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.searchDiseases(query));
  }
}

final diseaseDetectorNotifierProvider = StateNotifierProvider<DiseaseDetectorNotifier, AsyncValue<List<CropDisease>>>((ref) {
  final service = ref.watch(diseaseDetectorServiceProvider);
  return DiseaseDetectorNotifier(service);
});

final detectDiseaseProvider = FutureProvider.family<CropDisease?, ({String crop, List<String> symptoms})>((ref, args) async {
  final service = ref.watch(diseaseDetectorServiceProvider);
  return service.detectDisease(cropType: args.crop, symptoms: args.symptoms);
});

final diseaseByIdProvider = FutureProvider.family<CropDisease?, String>((ref, id) async {
  final service = ref.watch(diseaseDetectorServiceProvider);
  return service.getDiseaseById(id);
});
