import 'package:vriddhiapps/features/disease_detector/data/models/crop_disease_model.dart';

class DiseaseDetectorService {
  static final List<CropDisease> _commonDiseases = [
    CropDisease(
      id: 'wheat_rust',
      diseaseName: 'wheatRust',
      cropType: 'Wheat',
      symptoms: ['Orange/brown powder on leaves', 'Wilting of affected areas', 'Stunted growth'],
      cause: 'fungalInfectionPuccinia',
      severity: 'high',
      treatment: 'Apply fungicide (Hexaconazole 5% SC) spraying at first sign of disease',
      prevention: 'Use resistant varieties, ensure proper drainage, avoid overhead irrigation',
      imageUrl: 'assets/images/wheat_rust.png',
      confidenceScore: 85,
    ),
    CropDisease(
      id: 'rice_blast',
      diseaseName: 'riceBlast',
      cropType: 'Rice',
      symptoms: ['Gray-green spots on leaves', 'Brown necrotic lesions', 'White powder appearance'],
      cause: 'fungalInfectionMagnaporthe',
      severity: 'critical',
      treatment: 'Apply carbendazim (0.5%) or mancozeb (0.75%) immediately',
      prevention: 'Use disease-resistant varieties, maintain proper plant spacing, avoid nitrogen overdose',
      imageUrl: 'assets/images/rice_blast.png',
      confidenceScore: 92,
    ),
    CropDisease(
      id: 'cotton_leaf_curl',
      diseaseName: 'cottonLeafCurl',
      cropType: 'Cotton',
      symptoms: ['Curling and thickening of leaves', 'Discoloration (purple/yellow)', 'Stunted plants'],
      cause: 'viralInfectionWhiteflies',
      severity: 'critical',
      treatment: 'Control whitefly population with insecticide (Imidacloprid 17.8% SL)',
      prevention: 'Use resistant varieties, control weeds, use mulching, monitor for whiteflies',
      imageUrl: 'assets/images/cotton_leaf_curl.png',
      confidenceScore: 88,
    ),
    CropDisease(
      id: 'maize_blight',
      diseaseName: 'maizeBlight',
      cropType: 'Maize',
      symptoms: ['Tan/brown lesions on leaves', 'Progressive defoliation', 'Ear rot'],
      cause: 'fungalInfectionCochiobolus',
      severity: 'high',
      treatment: 'Apply mancozeb (75% WP) 0.2% or metalaxyl-based fungicides',
      prevention: 'Use resistant varieties, crop rotation, destroy infected residue, clean equipment',
      imageUrl: 'assets/images/maize_blight.png',
      confidenceScore: 79,
    ),
    CropDisease(
      id: 'potato_late_blight',
      diseaseName: 'potatoLateBlight',
      cropType: 'Potato',
      symptoms: ['Water-soaked lesions on leaves', 'White sporulation on undersides', 'Brown tuber rot'],
      cause: 'fungalInfectionPhytophthora',
      severity: 'critical',
      treatment: 'Apply mancozeb (75% WP) 2.5 kg/ha or metalaxyl combinations',
      prevention: 'Use disease-free seed potatoes, proper spacing, avoid overhead irrigation, roguing',
      imageUrl: 'assets/images/potato_late_blight.png',
      confidenceScore: 90,
    ),
    CropDisease(
      id: 'sugarcane_red_rot',
      diseaseName: 'sugarcaneRedRot',
      cropType: 'Sugarcane',
      symptoms: ['Red discoloration in vascular tissues', 'Premature wilting', 'Stunted shoots'],
      cause: 'fungalInfectionColletotrichum',
      severity: 'high',
      treatment: 'Use disease-free seed cane, apply Carbendazim 0.1% to seed cane before planting',
      prevention: 'Seed treatment with fungicide, use resistant varieties, hot water treatment',
      imageUrl: 'assets/images/sugarcane_red_rot.png',
      confidenceScore: 81,
    ),
    CropDisease(
      id: 'chickpea_wilt',
      diseaseName: 'chickpeaWilt',
      cropType: 'Chickpea',
      symptoms: ['Progressive wilting of plant', 'Yellowing of leaves', 'Vascular discoloration'],
      cause: 'fungalInfectionFusarium',
      severity: 'medium',
      treatment: 'Seed treatment with Trichoderma, apply Carbendazim 0.5% to soil',
      prevention: 'Use resistant varieties, crop rotation (3-year), avoid waterlogging, clean equipment',
      imageUrl: 'assets/images/chickpea_wilt.png',
      confidenceScore: 75,
    ),
    CropDisease(
      id: 'mustard_aphids',
      diseaseName: 'mustardAphids',
      cropType: 'Mustard',
      symptoms: ['Distortion of leaves and flowers', 'Yellow discoloration', 'Stunted pods', 'Sticky residue'],
      cause: 'pestInfestationAphids',
      severity: 'high',
      treatment: 'Spray Imidacloprid 17.8% SL or Acetamiprid 20% SP',
      prevention: 'Use reflective mulch, encourage predators, early sowing, crop residue removal',
      imageUrl: 'assets/images/mustard_aphids.png',
      confidenceScore: 87,
    ),
    CropDisease(
      id: 'groundnut_leaf_spot',
      diseaseName: 'Groundnut Leaf Spot',
      cropType: 'Groundnut',
      symptoms: ['Circular brown spots on leaves', 'Yellow halo around spots', 'Defoliation'],
      cause: 'Fungal infection by Cercospora arachidicola',
      severity: 'Medium',
      treatment: 'Apply Mancozeb 75% WP (2.5 kg/ha) or Chlorothalonil',
      prevention: 'Use resistant varieties, crop rotation, proper spacing, overhead irrigation avoided',
      imageUrl: 'assets/images/groundnut_leaf_spot.png',
      confidenceScore: 78,
    ),
    CropDisease(
      id: 'soybean_rust',
      diseaseName: 'Soybean Rust',
      cropType: 'Soybean',
      symptoms: ['Brown/tan pustules on leaves', 'Defoliation', 'Premature pod maturity'],
      cause: 'Fungal infection by Phakopsora meibomiae',
      severity: 'High',
      treatment: 'Apply Azoxystrobin 23% SC or Trifloxystrobin-based fungicides',
      prevention: 'Use resistant varieties, timely sowing, crop rotation, proper spacing',
      imageUrl: 'assets/images/soybean_rust.png',
      confidenceScore: 83,
    ),
  ];

  Future<List<CropDisease>> getAllDiseases() async {
    await Future.delayed(const Duration(seconds: 1));
    return _commonDiseases;
  }

  Future<List<CropDisease>> getDiseasesByCrop(String cropType) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _commonDiseases.where((disease) => disease.cropType.toLowerCase() == cropType.toLowerCase()).toList();
  }

  Future<CropDisease?> detectDisease({
    required String cropType,
    required List<String> symptoms,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simple symptom matching algorithm
    final matches = <CropDisease, int>{};
    
    for (var disease in _commonDiseases) {
      if (disease.cropType.toLowerCase() == cropType.toLowerCase()) {
        int matchCount = 0;
        for (var symptom in symptoms) {
          for (var diseaseSymptom in disease.symptoms) {
            if (diseaseSymptom.toLowerCase().contains(symptom.toLowerCase())) {
              matchCount++;
            }
          }
        }
        if (matchCount > 0) {
          matches[disease] = matchCount;
        }
      }
    }

    if (matches.isEmpty) return null;
    
    final topMatch = matches.entries.reduce((a, b) => a.value > b.value ? a : b);
    final confidence = ((topMatch.value / (symptoms.length * 3)) * 100).toInt().clamp(0, 100);
    
    return topMatch.key.copyWith(confidenceScore: confidence);
  }

  Future<List<CropDisease>> searchDiseases(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _commonDiseases
        .where((disease) => 
            disease.diseaseName.toLowerCase().contains(query.toLowerCase()) ||
            disease.cropType.toLowerCase().contains(query.toLowerCase()) ||
            disease.treatment.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<CropDisease?> getDiseaseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _commonDiseases.firstWhere((disease) => disease.id == id);
    } catch (e) {
      return null;
    }
  }
}
