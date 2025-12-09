import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/farm_calculator/data/models/calculator_model.dart';
import 'package:vriddhiapps/features/farm_calculator/data/services/calculator_service.dart';

/// Provider for calculator service
final calculatorServiceProvider = Provider((ref) => FarmCalculatorService());

/// State for seed quantity calculation
final seedQuantityProvider = StateProvider.family<FarmCalculation?, (String, double)>((ref, params) => null);

/// State for cost calculation
final farmingCostProvider = StateProvider.family<FarmCalculation?, (String, double)>((ref, params) => null);

/// State for yield calculation
final yieldCalculationProvider = StateProvider.family<FarmCalculation?, String>((ref, crop) => null);

/// Notifier for managing calculator calculations
class CalculatorNotifier extends StateNotifier<AsyncValue<FarmCalculation?>> {
  CalculatorNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> calculateSeed(String crop, double acres) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(calculatorServiceProvider);
      return service.calculateSeedQuantity(crop, acres);
    });
  }

  Future<void> calculateCost(
    String crop,
    double acres,
    double seedCost,
    double fertilizerCost,
    double laborDays,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(calculatorServiceProvider);
      return service.calculateFarmingCost(crop, acres, seedCost, fertilizerCost, laborDays);
    });
  }

  Future<void> calculateYield(
    String crop,
    double acres,
    double totalCost,
    double yieldPerAcre,
    double price,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(calculatorServiceProvider);
      return service.calculateYield(crop, acres, totalCost, yieldPerAcre, price);
    });
  }
}

/// Provider for calculator notifier
final calculatorNotifierProvider =
    StateNotifierProvider<CalculatorNotifier, AsyncValue<FarmCalculation?>>((ref) {
  return CalculatorNotifier(ref);
});

/// Provider for yield expectations
final yieldExpectationsProvider = Provider((ref) {
  final service = ref.watch(calculatorServiceProvider);
  return service.getYieldExpectations();
});
