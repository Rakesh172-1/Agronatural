class LoanScheme {
  final String id;
  final String name;
  final String minAmount;
  final String maxAmount;
  final double interestRate;
  final String tenure;
  final String eligibility;
  final String description;
  final String applicationDeadline;
  final String subsidy;
  final String processingTime;
  final String requiredDocuments;
  final String state;
  final bool isFavorite;

  LoanScheme({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.maxAmount,
    required this.interestRate,
    required this.tenure,
    required this.eligibility,
    required this.description,
    required this.applicationDeadline,
    required this.subsidy,
    required this.processingTime,
    required this.requiredDocuments,
    required this.state,
    this.isFavorite = false,
  });

  LoanScheme copyWith({
    String? id,
    String? name,
    String? minAmount,
    String? maxAmount,
    double? interestRate,
    String? tenure,
    String? eligibility,
    String? description,
    String? applicationDeadline,
    String? subsidy,
    String? processingTime,
    String? requiredDocuments,
    String? state,
    bool? isFavorite,
  }) {
    return LoanScheme(
      id: id ?? this.id,
      name: name ?? this.name,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      interestRate: interestRate ?? this.interestRate,
      tenure: tenure ?? this.tenure,
      eligibility: eligibility ?? this.eligibility,
      description: description ?? this.description,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      subsidy: subsidy ?? this.subsidy,
      processingTime: processingTime ?? this.processingTime,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      state: state ?? this.state,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
