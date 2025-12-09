import 'package:vriddhiapps/features/farm_calculator/data/models/calculator_model.dart';

class FarmCalculatorService {
  /// Seed quantity calculator - returns kg needed
  Future<FarmCalculation> calculateSeedQuantity(String crop, double acres) async {
    await Future.delayed(const Duration(milliseconds: 300));

    const seedRates = {
      'Wheat': 50.0,
      'Rice': 40.0,
      'Cotton': 2.5,
      'Maize': 20.0,
      'Soybean': 100.0,
      'Mustard': 5.0,
      'Bajra': 15.0,
      'Gram': 60.0,
    };

    final seedPerAcre = seedRates[crop] ?? 50.0;
    final totalSeed = seedPerAcre * acres;

    return FarmCalculation(
      type: 'seed',
      cropName: crop,
      landSizeAcres: acres,
      seedPerAcre: seedPerAcre,
      result: totalSeed.toStringAsFixed(2),
      unit: 'kg',
    );
  }

  /// Cost calculator - returns total farming cost
  Future<FarmCalculation> calculateFarmingCost(
    String crop,
    double acres,
    double seedCost,
    double fertilizerCost,
    double laborDays,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final seedRate = _getSeedRate(crop);
    final totalSeedCost = (seedRate * acres) * seedCost;
    final totalFertilizerCost = (150 * acres) * fertilizerCost; // 150 kg per acre
    final laborCost = laborDays * 300; // 300 per day
    final totalCost = totalSeedCost + totalFertilizerCost + laborCost + (200 * acres); // misc

    return FarmCalculation(
      type: 'cost',
      cropName: crop,
      landSizeAcres: acres,
      costPerUnit: totalCost / acres,
      result: totalCost.toStringAsFixed(0),
      unit: 'INR',
    );
  }

  /// Yield calculator - returns expected produce and profit
  Future<FarmCalculation> calculateYield(
    String crop,
    double acres,
    double totalCost,
    double expectedYieldPerAcre,
    double sellingPrice,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final totalYield = expectedYieldPerAcre * acres;
    final revenue = totalYield * sellingPrice;
    final profit = revenue - totalCost;

    return FarmCalculation(
      type: 'yield',
      cropName: crop,
      landSizeAcres: acres,
      expectedYield: totalYield,
      sellingPrice: sellingPrice,
      result: profit.toStringAsFixed(0),
      unit: 'INR (Profit)',
    );
  }

  /// Get standard seed rate for crop
  double _getSeedRate(String crop) {
    const rates = {
      'Wheat': 50.0,
      'Rice': 40.0,
      'Cotton': 2.5,
      'Maize': 20.0,
      'Soybean': 100.0,
      'Mustard': 5.0,
      'Bajra': 15.0,
      'Gram': 60.0,
    };
    return rates[crop] ?? 50.0;
  }

  /// Get expected yield per acre for crop
  Map<String, double> getYieldExpectations() {
    return {
      'Wheat': 50.0, // quintals per acre
      'Rice': 40.0,
      'Cotton': 8.0,
      'Maize': 25.0,
      'Soybean': 15.0,
      'Mustard': 12.0,
      'Bajra': 8.0,
      'Gram': 12.0,
    };
  }
}
