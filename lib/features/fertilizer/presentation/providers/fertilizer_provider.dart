import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/fertilizer/data/models/fertilizer_model.dart';
import 'package:vriddhiapps/features/fertilizer/data/services/fertilizer_service.dart';

/// Provider for FertilizerService singleton
final fertilizerServiceProvider = Provider((ref) => FertilizerService());

/// StateNotifier for managing fertilizer plan state
class FertilizerNotifier extends StateNotifier<AsyncValue<FertilizerPlan?>> {
  FertilizerNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  /// Fetch fertilizer plan for crop, land size, and soil type
  Future<void> fetchFertilizerPlan(
    String cropName,
    double landSizeAcre,
    String soilType,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(fertilizerServiceProvider);
      return service.getFertilizerPlan(cropName, landSizeAcre, soilType);
    });
  }

  /// Reset to initial state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// StateNotifierProvider for fertilizer plan
final fertilizerNotifierProvider =
    StateNotifierProvider.autoDispose<FertilizerNotifier, AsyncValue<FertilizerPlan?>>(
  (ref) => FertilizerNotifier(ref),
);

/// Provider for selected crop in fertilizer module
final selectedFertilizerCropProvider = StateProvider<String>((ref) => 'Wheat');

/// Provider for selected soil type
final selectedSoilTypeProvider = StateProvider<String>((ref) => 'Medium');

/// Provider for land size in acres
final landSizeProvider = StateProvider<double>((ref) => 1.0);
