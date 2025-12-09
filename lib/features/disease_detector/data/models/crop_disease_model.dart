class CropDisease {
  final String id;
  final String diseaseName;
  final String cropType;
  final List<String> symptoms;
  final String cause;
  final String severity;
  final String treatment;
  final String prevention;
  final String imageUrl;
  final int confidenceScore;

  CropDisease({
    required this.id,
    required this.diseaseName,
    required this.cropType,
    required this.symptoms,
    required this.cause,
    required this.severity,
    required this.treatment,
    required this.prevention,
    required this.imageUrl,
    this.confidenceScore = 0,
  });

  CropDisease copyWith({
    String? id,
    String? diseaseName,
    String? cropType,
    List<String>? symptoms,
    String? cause,
    String? severity,
    String? treatment,
    String? prevention,
    String? imageUrl,
    int? confidenceScore,
  }) {
    return CropDisease(
      id: id ?? this.id,
      diseaseName: diseaseName ?? this.diseaseName,
      cropType: cropType ?? this.cropType,
      symptoms: symptoms ?? this.symptoms,
      cause: cause ?? this.cause,
      severity: severity ?? this.severity,
      treatment: treatment ?? this.treatment,
      prevention: prevention ?? this.prevention,
      imageUrl: imageUrl ?? this.imageUrl,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }
}
