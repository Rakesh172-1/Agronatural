import 'package:vriddhiapps/features/fertilizer/data/models/fertilizer_model.dart';

/// Fertilizer service providing personalized fertilizer calculations and recommendations
/// 
/// This service implements the agricultural fertilizer calculation methodology:
/// 
/// CALCULATION FORMULA:
/// Fertilizer Required (kg) = (Nutrient Needed × Land Area) / Nutrient Concentration
/// 
/// PROCESS:
/// 1. Get base NPK requirement for soil type (kg/acre)
/// 2. Multiply by land size to get total nutrient needed
/// 3. Convert nutrient requirement to fertilizer product quantity
/// 4. Generate application schedule (split applications)
/// 
/// NPK Requirements by Soil Type (per acre):
/// - Light Soil (Sandy): N=120, P=60, K=40
/// - Medium Soil (Loamy): N=100, P=50, K=30
/// - Heavy Soil (Clay): N=80, P=40, K=20
class FertilizerService {
  /// Get personalized fertilizer plan for crop, land size, and soil type
  /// 
  /// Parameters:
  /// - [cropName]: Type of crop (e.g., "Wheat", "Rice", "Maize")
  /// - [landSizeAcre]: Total cultivable area in acres
  /// - [soilType]: Soil classification (Light, Medium, Heavy)
  /// 
  /// Returns: FertilizerPlan containing:
  /// - NPK requirement breakdown
  /// - Fertilizer product recommendations
  /// - Application timing and quantities
  /// 
  /// Example:
  /// ```
  /// plan = getFertilizerPlan("Wheat", 2.5, "Medium")
  /// // Returns plan for 2.5 acres with:
  /// // N: 250 kg, P: 125 kg, K: 75 kg
  /// // Urea: 543 kg, DAP: 272 kg, MOP: 125 kg
  /// ```
  Future<FertilizerPlan> getFertilizerPlan(
    String cropName,
    double landSizeAcre,
    String soilType,
  ) async {
    // Simulate API delay (in real app, would fetch from database/API)
    await Future.delayed(const Duration(milliseconds: 600));

    // STEP 1: Get base NPK requirement per acre for soil type
    // This accounts for soil nutrient retention capacity
    final npkBase = _getNPKBase(soilType);

    // STEP 2: Calculate total nutrient needed
    // Formula: Total Nutrient = Base Requirement (kg/acre) × Land Size (acres)
    // This multiplies the per-acre requirement by total area
    final nitrogen = (npkBase['nitrogen'] as double) * landSizeAcre;
    final phosphorus = (npkBase['phosphorus'] as double) * landSizeAcre;
    final potassium = (npkBase['potassium'] as double) * landSizeAcre;

    // Create NPK recommendation object
    final npk = NPKRecommendation(
      nitrogen: nitrogen,
      phosphorus: phosphorus,
      potassium: potassium,
    );

    // STEP 3: Convert nutrient requirements to fertilizer product quantities
    // Formula: Fertilizer Required = Nutrient Needed / Nutrient Concentration
    // Example: 100 kg N ÷ 0.46 (Urea concentration) = 217 kg Urea
    final products = _getProductRecommendations(
      cropName,
      nitrogen,
      phosphorus,
      potassium,
      landSizeAcre,
    );

    // STEP 4: Generate complete fertilizer plan with application schedule
    return FertilizerPlan(
      cropName: cropName,
      landSizeAcre: landSizeAcre,
      soilType: soilType,
      npkRequirement: npk,
      products: products,
      applicationMethod:
          'Apply fertilizers in 2-3 splits during growing season. '
          'First split at sowing/planting, second at flowering, third at grain filling.',
    );
  }

  /// Get base NPK values per acre based on soil type
  /// 
  /// Soil types have different nutrient retention capacities:
  /// - Light (Sandy): Poor water/nutrient retention → Higher requirement
  /// - Medium (Loamy): Good retention → Standard requirement (baseline)
  /// - Heavy (Clay): High retention → Lower requirement
  /// 
  /// Values based on Indian agricultural standards for standard crops
  Map<String, double> _getNPKBase(String soilType) {
    switch (soilType) {
      case 'Light':
        // Light sandy soil: nutrients leach quickly, needs higher application
        return {'nitrogen': 120, 'phosphorus': 60, 'potassium': 40};
      case 'Medium':
        // Medium loamy soil: balanced retention (standard baseline)
        return {'nitrogen': 100, 'phosphorus': 50, 'potassium': 30};
      case 'Heavy':
        // Heavy clay soil: nutrients retained well, needs lower application
        return {'nitrogen': 80, 'phosphorus': 40, 'potassium': 20};
      default:
        // Default to medium soil type
        return {'nitrogen': 100, 'phosphorus': 50, 'potassium': 30};
    }
  }

  /// Generate product-specific fertilizer recommendations
  /// 
  /// NUTRIENT CONTENT IN STANDARD FERTILIZERS:
  /// - Urea: 46% N (nitrogen only)
  /// - DAP (Di-ammonium Phosphate): 18% N + 46% P₂O₅
  /// - MOP (Muriate of Potash): 60% K₂O (potassium only)
  /// 
  /// CALCULATION PROCESS:
  /// 1. Divide required nutrient by nutrient concentration in product
  /// 2. Result is quantity of fertilizer needed
  /// 3. Example: Need 100 kg N → 100 ÷ 0.46 = 217 kg Urea
  List<FertilizerProduct> _getProductRecommendations(
    String cropName,
    double nitrogen,
    double phosphorus,
    double potassium,
    double landSizeAcre,
  ) {
    // CALCULATE FERTILIZER QUANTITIES USING NUTRIENT CONCENTRATION
    
    // Urea: 46% nitrogen content
    // Formula: Quantity needed = Nitrogen required ÷ 0.46
    final ureaQuantity = (nitrogen / 0.46).round().toDouble();
    
    // DAP: 46% phosphorus content (P₂O₅)
    // Formula: Quantity needed = Phosphorus required ÷ 0.46
    final dapQuantity = (phosphorus / 0.46).round().toDouble();
    
    // MOP: 60% potassium content (K₂O)
    // Formula: Quantity needed = Potassium required ÷ 0.60
    final mopQuantity = (potassium / 0.60).round().toDouble();

    return [
      FertilizerProduct(
        name: 'Urea',
        quantityKg: ureaQuantity,
        timing: 'In 2-3 splits',
        instruction:
            'First split at sowing (30%), second at flowering (40%), third at grain filling (30%)',
      ),
      FertilizerProduct(
        name: 'DAP (Di-ammonium Phosphate)',
        quantityKg: dapQuantity,
        timing: 'At sowing',
        instruction: 'Apply entire quantity at time of sowing',
      ),
      FertilizerProduct(
        name: 'MOP (Muriate of Potash)',
        quantityKg: mopQuantity,
        timing: 'In 2 splits',
        instruction:
            'First split at sowing (50%), second at flowering (50%)',
      ),
    ];
  }
}
