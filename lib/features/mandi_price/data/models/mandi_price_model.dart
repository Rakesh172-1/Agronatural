/// Represents a single day's mandi price data point
class MandiPricePoint {
  final DateTime date;
  final double price;

  MandiPricePoint({
    required this.date,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'price': price,
  };

  factory MandiPricePoint.fromJson(Map<String, dynamic> json) => MandiPricePoint(
    date: DateTime.parse(json['date'] as String),
    price: (json['price'] as num).toDouble(),
  );
}

/// Represents current mandi prices for a crop
class MandiPrice {
  final String mandiName;
  final String state;
  final String district;
  final String crop;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final List<MandiPricePoint> priceHistory;
  final DateTime lastUpdated;

  MandiPrice({
    required this.mandiName,
    required this.state,
    required this.district,
    required this.crop,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.priceHistory,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'mandiName': mandiName,
    'state': state,
    'district': district,
    'crop': crop,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'modalPrice': modalPrice,
    'priceHistory': priceHistory.map((p) => p.toJson()).toList(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory MandiPrice.fromJson(Map<String, dynamic> json) => MandiPrice(
    mandiName: json['mandiName'] as String,
    state: json['state'] as String,
    district: json['district'] as String,
    crop: json['crop'] as String,
    minPrice: (json['minPrice'] as num).toDouble(),
    maxPrice: (json['maxPrice'] as num).toDouble(),
    modalPrice: (json['modalPrice'] as num).toDouble(),
    priceHistory: (json['priceHistory'] as List<dynamic>)
        .map((p) => MandiPricePoint.fromJson(p as Map<String, dynamic>))
        .toList(),
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  );
}
