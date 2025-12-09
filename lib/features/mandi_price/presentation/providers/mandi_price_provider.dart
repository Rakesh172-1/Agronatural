import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/mandi_price/data/models/mandi_price_model.dart';
import 'package:vriddhiapps/features/mandi_price/data/services/mandi_price_service.dart';

/// Provider for MandiPriceService singleton
final mandiPriceServiceProvider = Provider((ref) => MandiPriceService());

/// StateNotifier for managing mandi prices state
class MandiPriceNotifier extends StateNotifier<AsyncValue<List<MandiPrice>>> {
  MandiPriceNotifier(this.ref)
      : super(const AsyncValue.data([]));

  final Ref ref;

  /// Fetch mandi prices for selected state, district, and crop
  Future<void> fetchPrices(String selectedState, String district, String crop) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(mandiPriceServiceProvider);
      return service.getPrices(
        state: selectedState,
        district: district,
        crop: crop,
      );
    });
  }

  /// Reset to empty list
  void reset() {
    state = const AsyncValue.data([]);
  }
}

/// StateNotifierProvider for mandi prices
final mandiPriceNotifierProvider =
    StateNotifierProvider.autoDispose<MandiPriceNotifier, AsyncValue<List<MandiPrice>>>(
  (ref) => MandiPriceNotifier(ref),
);

/// Provider for selected state
final selectedStateProvider = StateProvider<String>((ref) => 'Punjab');

/// Provider for selected district
final selectedDistrictProvider = StateProvider<String>((ref) => 'Amritsar');

/// Provider for selected crop in mandi search
final selectedMandiCropProvider = StateProvider<String>((ref) => 'Wheat');

/// Provider for available districts based on selected state
final availableDistrictsProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(mandiPriceServiceProvider);
  final state = ref.watch(selectedStateProvider);
  return service.getDistricts(state);
});
