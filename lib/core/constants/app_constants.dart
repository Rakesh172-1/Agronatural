/// App-wide constants
class AppConstants {
  AppConstants._();

  // API and data related
  static const String defaultLocation = 'Punjab';
  static const String defaultDistrict = 'Amritsar';
  static const String appName = 'Vriddhi';
  
  // Hive box names for local caching
  static const String weatherBoxName = 'weather_cache';
  static const String mandiPriceBoxName = 'mandi_price_cache';
  static const String cropPlannerBoxName = 'crop_planner_cache';
  
  // Cache duration in minutes
  static const int cacheDurationMinutes = 60;
  
  // Crops list
  static const List<String> crops = [
    'Wheat',
    'Paddy',
    'Maize',
    'Cotton',
    'Soybean',
    'Mustard',
    'Sugarcane',
    'Potato',
    'rice',
    'Millet'
  ];
  
  // Seasons
  static const List<String> seasons = ['Rabi', 'Kharif', 'Zaid'];
  
  // Soil types
  static const List<String> soilTypes = ['Sandy', 'Loam', 'Clay', 'Medium'];
  
  // Indian states
  static const List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];
}
