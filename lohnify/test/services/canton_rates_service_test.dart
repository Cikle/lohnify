import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lohnify/services/canton_rates_service.dart';
import 'package:lohnify/models/contribution_rates.dart';

@GenerateMocks([http.Client])
void main() {
  group('CantonRatesService Tests', () {
    late CantonRatesService cantonService;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      cantonService = CantonRatesService(prefs);
    });

    test('fetchCantonRates returns default rates on API failure', () async {
      final rates = await cantonService.fetchCantonRates();
      expect(rates, equals(ContributionRates.defaultCantons));
      expect(rates['ZH']?.taxRate, equals(22.0));
    });

    test('getLastUpdate returns null when no update timestamp exists', () {
      final lastUpdate = cantonService.getLastUpdate();
      expect(lastUpdate, isNull);
    });

    test('fetchCantonRates handles corrupted cache', () async {
      // Set up corrupted cache
      await prefs.setString('canton_rates_cache', 'corrupted data');
      await prefs.setInt('canton_rates_cache_timestamp', DateTime.now().millisecondsSinceEpoch);

      final rates = await cantonService.fetchCantonRates();
      expect(rates, equals(ContributionRates.defaultCantons));
    });
  });
}
