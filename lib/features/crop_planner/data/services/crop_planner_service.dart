import 'package:vriddhiapps/features/crop_planner/data/models/crop_plan_model.dart';

/// Mock crop planner service providing crop planning data
class CropPlannerService {
  /// Get crop plan for selected season and crop
  Future<CropPlan> getCropPlan(String season, String cropName) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    const daysToMaturity = 120;

    // Mock data based on crop selection
    final cropData = _getCropData(season, cropName);

    return CropPlan(
      cropName: cropName,
      season: season,
      recommendedVariety: cropData['variety'] as String,
      sowingWindowStart: cropData['sowingStart'] as DateTime,
      sowingWindowEnd: cropData['sowingEnd'] as DateTime,
      harvestWindowStart: cropData['harvestStart'] as DateTime,
      harvestWindowEnd: cropData['harvestEnd'] as DateTime,
      daysToMaturity: daysToMaturity,
      tasks: [
        CropTask(
          name: 'Sowing',
          description: 'Prepare field and sow seeds',
          daysFromSowing: 0,
          duration: 3,
        ),
        CropTask(
          name: 'First Irrigation',
          description: 'First irrigation after germination',
          daysFromSowing: 21,
          duration: 1,
        ),
        CropTask(
          name: 'First Fertilizer Application',
          description: 'Apply first dose of fertilizer',
          daysFromSowing: 30,
          duration: 2,
        ),
        CropTask(
          name: 'Second Fertilizer Application',
          description: 'Apply second dose of fertilizer',
          daysFromSowing: 60,
          duration: 2,
        ),
        CropTask(
          name: 'Harvest',
          description: 'Harvest the crop',
          daysFromSowing: daysToMaturity,
          duration: 5,
        ),
      ],
    );
  }

  /// Get mock crop data based on season and crop
  Map<String, dynamic> _getCropData(String season, String cropName) {
    final now = DateTime.now();

    // Return different windows based on season
    if (season == 'Rabi') {
      return {
        'variety': 'HD 2967 (Wheat) / PR 126 (Paddy)',
        'sowingStart': DateTime(now.year, 10, 15),
        'sowingEnd': DateTime(now.year, 11, 30),
        'harvestStart': DateTime(now.year + 1, 3, 15),
        'harvestEnd': DateTime(now.year + 1, 4, 30),
      };
    } else if (season == 'Kharif') {
      return {
        'variety': 'Indira Basmati / Sorghum CSH 16',
        'sowingStart': DateTime(now.year, 6, 15),
        'sowingEnd': DateTime(now.year, 7, 31),
        'harvestStart': DateTime(now.year, 10, 15),
        'harvestEnd': DateTime(now.year, 11, 30),
      };
    } else {
      // Zaid
      return {
        'variety': 'Local variety / Hybrid variety',
        'sowingStart': DateTime(now.year, 3, 1),
        'sowingEnd': DateTime(now.year, 4, 15),
        'harvestStart': DateTime(now.year, 6, 1),
        'harvestEnd': DateTime(now.year, 7, 15),
      };
    }
  }
}
