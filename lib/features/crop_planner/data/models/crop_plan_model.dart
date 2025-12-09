/// Represents a single task in crop planning
class CropTask {
  final String name;
  final String description;
  final int daysFromSowing;
  final int duration;

  CropTask({
    required this.name,
    required this.description,
    required this.daysFromSowing,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'daysFromSowing': daysFromSowing,
    'duration': duration,
  };

  factory CropTask.fromJson(Map<String, dynamic> json) => CropTask(
    name: json['name'] as String,
    description: json['description'] as String,
    daysFromSowing: json['daysFromSowing'] as int,
    duration: json['duration'] as int,
  );
}

/// Represents a complete crop plan with timing and tasks
class CropPlan {
  final String cropName;
  final String season;
  final String recommendedVariety;
  final DateTime sowingWindowStart;
  final DateTime sowingWindowEnd;
  final DateTime harvestWindowStart;
  final DateTime harvestWindowEnd;
  final int daysToMaturity;
  final List<CropTask> tasks;

  CropPlan({
    required this.cropName,
    required this.season,
    required this.recommendedVariety,
    required this.sowingWindowStart,
    required this.sowingWindowEnd,
    required this.harvestWindowStart,
    required this.harvestWindowEnd,
    required this.daysToMaturity,
    required this.tasks,
  });



  Map<String, dynamic> toJson() => {
    'cropName': cropName,
    'season': season,
    'recommendedVariety': recommendedVariety,
    'sowingWindowStart': sowingWindowStart.toIso8601String(),
    'sowingWindowEnd': sowingWindowEnd.toIso8601String(),
    'harvestWindowStart': harvestWindowStart.toIso8601String(),
    'harvestWindowEnd': harvestWindowEnd.toIso8601String(),
    'daysToMaturity': daysToMaturity,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };

  factory CropPlan.fromJson(Map<String, dynamic> json) => CropPlan(
    cropName: json['cropName'] as String,
    season: json['season'] as String,
    recommendedVariety: json['recommendedVariety'] as String,
    sowingWindowStart: DateTime.parse(json['sowingWindowStart'] as String),
    sowingWindowEnd: DateTime.parse(json['sowingWindowEnd'] as String),
    harvestWindowStart: DateTime.parse(json['harvestWindowStart'] as String),
    harvestWindowEnd: DateTime.parse(json['harvestWindowEnd'] as String),
    daysToMaturity: json['daysToMaturity'] as int,
    tasks: (json['tasks'] as List<dynamic>)
        .map((t) => CropTask.fromJson(t as Map<String, dynamic>))
        .toList(),
  );
}
