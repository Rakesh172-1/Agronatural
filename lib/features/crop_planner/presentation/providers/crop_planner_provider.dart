import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/crop_planner/data/models/crop_plan_model.dart';
import 'package:vriddhiapps/features/crop_planner/data/services/crop_planner_service.dart';

/// Provider for CropPlannerService singleton
final cropPlannerServiceProvider = Provider((ref) => CropPlannerService());

/// StateNotifier for managing crop planner state
class CropPlannerNotifier extends StateNotifier<AsyncValue<CropPlan?>> {
  CropPlannerNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  /// Fetch crop plan for selected season and crop
  Future<void> fetchCropPlan(String season, String cropName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(cropPlannerServiceProvider);
      return service.getCropPlan(season, cropName);
    });
  }

  /// Reset to initial state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// StateNotifierProvider for crop planner
final cropPlannerNotifierProvider =
    StateNotifierProvider.autoDispose<CropPlannerNotifier, AsyncValue<CropPlan?>>(
  (ref) => CropPlannerNotifier(ref),
);

/// Provider for selected season (simple state)
final selectedSeasonProvider = StateProvider<String>((ref) => 'Rabi');

/// Provider for selected crop (simple state)
final selectedCropProvider = StateProvider<String>((ref) => 'Wheat');
