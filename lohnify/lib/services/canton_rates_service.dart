import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contribution_rates.dart';

class CantonRatesService {
  static const String _baseUrl = 'https://www.estv.admin.ch/api/tax/cantons';
  static const String _cacheKey = 'canton_rates_cache';
  static const Duration _updateInterval = Duration(days: 1);
  
  final SharedPreferences _prefs;
  
  CantonRatesService(this._prefs);

  Future<Map<String, CantonData>> fetchCantonRates() async {
    try {
      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(
        _prefs.getInt('${_cacheKey}_timestamp') ?? 0
      );
      
      if (DateTime.now().difference(lastUpdate) < _updateInterval) {
        final cached = _prefs.getString(_cacheKey);
        if (cached != null) {
          try {
            return Map<String, CantonData>.from(
              json.decode(cached).map((key, value) => 
                MapEntry(key, CantonData.fromJson(value))
              )
            );
          } catch (e) {
            debugPrint('Failed to parse cached canton rates: $e');
            // If cache is corrupted, continue to fetch new data
          }
        }
      }

      try {
        final response = await http.get(Uri.parse(_baseUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          await _cacheRates(data);
          return Map<String, CantonData>.from(
            data.map((key, value) => 
              MapEntry(key, CantonData.fromJson(value))
            )
          );
        } else {
          debugPrint('Failed to fetch canton rates: HTTP ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Network error while fetching canton rates: $e');
      }
    } catch (e) {
      debugPrint('Error in fetchCantonRates: $e');
    }

    // Fallback to default rates if anything fails
    return ContributionRates.defaultCantons;
  }

  Future<void> _cacheRates(Map<String, dynamic> data) async {
    await _prefs.setString(_cacheKey, json.encode(data));
    await _prefs.setInt(
      '${_cacheKey}_timestamp',
      DateTime.now().millisecondsSinceEpoch
    );
  }

  DateTime? getLastUpdate() {
    final timestamp = _prefs.getInt('${_cacheKey}_timestamp');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
}
