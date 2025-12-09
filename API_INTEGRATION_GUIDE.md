# API Integration Guide - KrishiLite Enhanced

## 🌤️ Weather Module - Open-Meteo Integration

### What's Updated
- Integrated **Open-Meteo API** (free, no authentication required)
- Default location changed to **Punjab (Amritsar)** - Coordinates: 31.6340°N, 74.8711°E
- Real weather data with 7-day forecast
- Proper weather code to description mapping (WMO standard)

### API Details
```
Endpoint: https://api.open-meteo.com/v1/forecast
Method: GET
Parameters:
  - latitude: 31.6340 (Punjab/Amritsar)
  - longitude: 74.8711
  - current: temperature_2m, weather_code, relative_humidity_2m, wind_speed_10m
  - daily: weather_code, temperature_2m_max, temperature_2m_min, etc.
  - timezone: Asia/Kolkata
  - forecast_days: 7
```

### Code Location
- **Service**: `lib/features/weather/data/services/weather_service.dart`
- **Provider**: `lib/features/weather/presentation/providers/weather_provider.dart`
- **Screen**: `lib/features/weather/presentation/screens/weather_screen.dart`

### Features
✅ Real-time weather from Open-Meteo
✅ 7-day forecast with actual API data
✅ Fallback to mock data if API fails
✅ Improved UI with gradient cards
✅ Proper error handling
✅ WMO weather code support (0-99 codes mapped to descriptions)

### Customizing Location
To change location, update coordinates in `weather_screen.dart`:
```dart
final double latitude = 31.6340;  // Change this
final double longitude = 74.8711; // Change this
```

---

## 💹 Mandi Prices Module - API Ready

### What's Updated
- Default location: **Punjab** (with 8 districts)
- API key: `579b464db66ec23bdd00000195e46634807d4b16797104c1f6abf986`
- Mock implementation with Punjab-specific data
- Beautiful improved UI with price trends

### Current Implementation
**Status**: Using mock data with fallback API structure

The service is structured to easily integrate with real APIs:
```dart
// Easy to replace with real endpoint
final response = await _dio.get(
  'https://api.agromarketprices.com/v1/prices',
  queryParameters: {
    'state': state,
    'district': district,
    'commodity': crop,
    'api_key': _apiKey,
  },
);
```

### Punjab Districts Included
1. Amritsar (default)
2. Ludhiana
3. Chandigarh
4. Patiala
5. Bathinda
6. Jalandhar
7. Kapurthala
8. Moga

### Code Location
- **Service**: `lib/features/mandi_price/data/services/mandi_price_service.dart`
- **Provider**: `lib/features/mandi_price/presentation/providers/mandi_price_provider.dart`
- **Screen**: `lib/features/mandi_price/presentation/screens/mandi_price_screen.dart`

### Real API Integration Steps
1. Replace `_getMockPrices()` with actual API response parsing
2. Update endpoint from `https://api.agromarketprices.com/v1/prices`
3. Use provided API key in requests
4. Keep fallback to mock data for resilience

---

## 🎨 UI Enhancements

### Weather Screen
- **Gradient Cards**: Green gradient background (from #2D6A4F to #52B788)
- **Large Icons**: 80px weather icons
- **Data Grid**: Humidity, wind speed, last updated time
- **7-Day Forecast**: Individual cards with date, condition, temp range
- **Pull-to-Refresh**: Refreshes weather data

### Mandi Prices Screen
- **Input Cards**: Beautiful dropdown fields with green borders
- **Price Chart**: fl_chart LineChart with gradient fill
- **Mandi Cards**: Three-color coded price comparisons
- **Price Grid**: Min, Max, Modal prices clearly displayed
- **Error Handling**: Graceful error messages

### Color Scheme
```
Primary Green:   #2D6A4F (dark green for headers)
Secondary:       #52B788 (light green for accents)
Tertiary:        #74C69D (accent green)
Temperature Hot: #FF5252 (red for max temps)
Temperature Cold: #2196F3 (blue for min temps)
Average:         #4CAF50 (green for modal prices)
```

---

## 📱 UI/UX Improvements

### Weather Module
- ✅ Gradient background cards
- ✅ Large, readable temperature display
- ✅ Icon-based weather visualization
- ✅ Organized data layout (humidity, wind, update time)
- ✅ Responsive 7-day forecast list

### Mandi Prices Module
- ✅ Clean input form with bordered dropdowns
- ✅ Async district loading
- ✅ Interactive price chart with grid lines
- ✅ Color-coded price cards (blue, orange, green mandis)
- ✅ Detailed price breakdown (min/max/modal)
- ✅ Smooth chart animations

---

## 🔄 Data Flow

### Weather Module Flow
```
User refreshes or app loads
    ↓
WeatherScreen calls fetchWeather()
    ↓
WeatherNotifier calls Open-Meteo API
    ↓
Service returns Weather object
    ↓
State updates with AsyncValue<Weather>
    ↓
UI renders current weather + 7-day forecast
```

### Mandi Prices Flow
```
User selects state/district/crop
    ↓
Districts auto-load based on state
    ↓
User clicks "भाव देखें" (View Prices)
    ↓
Service fetches prices for selection
    ↓
State updates with prices list
    ↓
UI shows chart + mandi price cards
```

---

## 🛠️ Testing APIs

### Test Weather API
```bash
# Get current weather for Punjab (Amritsar)
curl "https://api.open-meteo.com/v1/forecast?latitude=31.6340&longitude=74.8711&current=temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m&timezone=Asia/Kolkata"

# Get 7-day forecast
curl "https://api.open-meteo.com/v1/forecast?latitude=31.6340&longitude=74.8711&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Asia/Kolkata&forecast_days=7"
```

### Test Mandi API
```bash
# When endpoint is ready:
curl "https://api.agromarketprices.com/v1/prices?state=Punjab&district=Amritsar&commodity=Wheat&api_key=579b464db66ec23bdd00000195e46634807d4b16797104c1f6abf986"
```

---

## 🚀 Next Steps

### To Deploy with Real APIs:
1. **Weather**: Already using real Open-Meteo API ✅
2. **Mandi Prices**: 
   - Confirm endpoint with API provider
   - Validate API response format
   - Update `_parsePricesResponse()` method
   - Test with real data

### To Customize:
1. **Change Default Location**: Update coordinates in weather_screen.dart
2. **Add More States**: Update `indianStates` list in app_constants.dart
3. **Add More Crops**: Update `crops` list in app_constants.dart
4. **Modify UI Colors**: Update `app_theme.dart`

---

## 📊 WMO Weather Codes (Open-Meteo)

The weather service automatically converts WMO codes to descriptions:

| Code | Description |
|------|-------------|
| 0 | Clear |
| 1-2 | Partly Cloudy |
| 3 | Overcast |
| 45-48 | Foggy |
| 51-55 | Drizzle |
| 61-65 | Rain |
| 71-75 | Snow |
| 80-82 | Rain Showers |
| 85-86 | Snow Showers |
| 95-99 | Thunderstorm |

---

## 🔐 API Keys

### Open-Meteo (Weather)
- **Status**: Free tier (no key needed)
- **Rate Limit**: 10,000 requests/day
- **Authentication**: None required

### Mandi Prices
- **API Key**: `579b464db66ec23bdd00000195e46634807d4b16797104c1f6abf986`
- **Status**: Ready for integration
- **Authentication**: API key in query params

---

## 💡 Best Practices

1. **Always include fallback mock data** - Improves user experience if API fails
2. **Cache API responses** - Use Hive boxes to store recent data
3. **Handle errors gracefully** - Show user-friendly messages
4. **Test with real devices** - Different locations may have different API behavior
5. **Monitor API rate limits** - Track usage to avoid hitting limits

---

## 📝 Code Examples

### Fetching Weather
```dart
ref.read(weatherNotifierProvider.notifier).fetchWeather(
  latitude: 31.6340,
  longitude: 74.8711,
  location: 'Punjab, India',
);
```

### Fetching Mandi Prices
```dart
ref.read(mandiPriceNotifierProvider.notifier).fetchPrices(
  'Punjab',
  'Amritsar',
  'Wheat',
);
```

---

**Last Updated**: December 2024
**API Status**: ✅ Weather (Live) | 🚧 Mandi (Ready)
**Version**: 1.1.0

