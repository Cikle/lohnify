import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contribution_rates.dart';

class RatesService {
  static const String _baseUrl = 'https://www.bsv.admin.ch/api/rates';
  static const String _cacheKey = 'contribution_rates_cache';
  static const Duration _cacheExpiration = Duration(hours: 24);
  
  final SharedPreferences _prefs;
  
  RatesService(this._prefs);
  
  Future<ContributionRates> getRates() async {
    final cachedData = _prefs.getString(_cacheKey);
    final cacheTimestamp = _prefs.getInt('${_cacheKey}_timestamp') ?? 0;
    
    if (cachedData != null && 
        DateTime.now().millisecondsSinceEpoch - cacheTimestamp < _cacheExpiration.inMilliseconds) {
      return ContributionRates.fromJson(json.decode(cachedData));
    }
    
    try {
      final response = await http.get(Uri.parse('$_baseUrl/current'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _cacheRates(data);
        return ContributionRates.fromJson(data);
      }
    } catch (e) {
      if (cachedData != null) {
        return ContributionRates.fromJson(json.decode(cachedData));
      }
    }
    
    return ContributionRates(); // Fallback to default rates
  }
  
  Future<void> _cacheRates(Map<String, dynamic> data) async {
    await _prefs.setString(_cacheKey, json.encode(data));
    await _prefs.setInt('${_cacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
}
