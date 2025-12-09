/// Represents NPK (Nitrogen, Phosphorus, Potassium) requirements
class NPKRecommendation {
  final double nitrogen; // kg per acre
  final double phosphorus; // kg per acre
  final double potassium; // kg per acre

  NPKRecommendation({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
  });

  Map<String, dynamic> toJson() => {
    'nitrogen': nitrogen,
    'phosphorus': phosphorus,
    'potassium': potassium,
  };

  factory NPKRecommendation.fromJson(Map<String, dynamic> json) =>
      NPKRecommendation(
        nitrogen: (json['nitrogen'] as num).toDouble(),
        phosphorus: (json['phosphorus'] as num).toDouble(),
        potassium: (json['potassium'] as num).toDouble(),
      );
}

/// Represents a specific fertilizer product recommendation
class FertilizerProduct {
  final String name; // e.g., "Urea", "DAP", "MOP"
  final double quantityKg; // Recommended quantity in kg
  final String timing; // e.g., "At sowing", "First split", "Second split"
  final String instruction;

  FertilizerProduct({
    required this.name,
    required this.quantityKg,
    required this.timing,
    required this.instruction,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantityKg': quantityKg,
    'timing': timing,
    'instruction': instruction,
  };

  factory FertilizerProduct.fromJson(Map<String, dynamic> json) =>
      FertilizerProduct(
        name: json['name'] as String,
        quantityKg: (json['quantityKg'] as num).toDouble(),
        timing: json['timing'] as String,
        instruction: json['instruction'] as String,
      );
}

/// Represents a complete fertilizer plan for a crop
class FertilizerPlan {
  final String cropName;
  final double landSizeAcre;
  final String soilType;
  final NPKRecommendation npkRequirement;
  final List<FertilizerProduct> products;
  final String applicationMethod;

  FertilizerPlan({
    required this.cropName,
    required this.landSizeAcre,
    required this.soilType,
    required this.npkRequirement,
    required this.products,
    required this.applicationMethod,
  });

  Map<String, dynamic> toJson() => {
    'cropName': cropName,
    'landSizeAcre': landSizeAcre,
    'soilType': soilType,
    'npkRequirement': npkRequirement.toJson(),
    'products': products.map((p) => p.toJson()).toList(),
    'applicationMethod': applicationMethod,
  };

  factory FertilizerPlan.fromJson(Map<String, dynamic> json) => FertilizerPlan(
    cropName: json['cropName'] as String,
    landSizeAcre: (json['landSizeAcre'] as num).toDouble(),
    soilType: json['soilType'] as String,
    npkRequirement: NPKRecommendation.fromJson(
        json['npkRequirement'] as Map<String, dynamic>),
    products: (json['products'] as List<dynamic>)
        .map((p) => FertilizerProduct.fromJson(p as Map<String, dynamic>))
        .toList(),
    applicationMethod: json['applicationMethod'] as String,
  );
}