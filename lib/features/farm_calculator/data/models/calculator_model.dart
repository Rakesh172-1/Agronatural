/// Farm calculator model for cost and yield calculations
class FarmCalculation {
  final String type; // 'seed', 'cost', 'yield'
  final String cropName;
  final double landSizeAcres;
  final double? seedPerAcre;
  final double? costPerUnit;
  final double? expectedYield;
  final double? sellingPrice;
  final String result;
  final String unit;

  FarmCalculation({
    required this.type,
    required this.cropName,
    required this.landSizeAcres,
    this.seedPerAcre,
    this.costPerUnit,
    this.expectedYield,
    this.sellingPrice,
    required this.result,
    required this.unit,
  });
}
