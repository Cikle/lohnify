import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lohnify/services/rates_service.dart';
import 'package:lohnify/models/contribution_rates.dart';

@GenerateMocks([http.Client])
void main() {
  group('RatesService Tests', () {
    late RatesService ratesService;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      ratesService = RatesService(prefs);
    });

    test('getRates returns default rates when API fails', () async {
      final rates = await ratesService.getRates();
      expect(rates, isA<ContributionRates>());
      expect(rates.ahvEmployee, equals(5.3));
      expect(rates.ivEmployee, equals(0.7));
    });

    test('getRates uses cached data when available', () async {
      // Set up mock cached data
      final mockData = {
        'ahvEmployee': 5.5,
        'ivEmployee': 0.8,
      };
      await prefs.setString('contribution_rates_cache', '{"ahvEmployee":5.5,"ivEmployee":0.8}');
      await prefs.setInt('contribution_rates_cache_timestamp', DateTime.now().millisecondsSinceEpoch);

      final rates = await ratesService.getRates();
      expect(rates.ahvEmployee, equals(5.5));
      expect(rates.ivEmployee, equals(0.8));
    });

    test('getRates handles corrupted cache gracefully', () async {
      // Set up corrupted cache
      await prefs.setString('contribution_rates_cache', 'corrupted data');
      await prefs.setInt('contribution_rates_cache_timestamp', DateTime.now().millisecondsSinceEpoch);

      final rates = await ratesService.getRates();
      expect(rates, isA<ContributionRates>());
      // Should fall back to default values
      expect(rates.ahvEmployee, equals(5.3));
    });
  });
}
