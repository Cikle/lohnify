# Lohnify - Swiss Salary Calculator

Lohnify is a Flutter-based mobile application designed to help users in Switzerland calculate their net salary by considering various deductions including social security contributions, pension funds, and cantonal tax rates.

## Features

- Gross to net salary calculation
- Support for all 26 Swiss cantons with their specific tax rates
- Social security deductions (AHV, IV, EO, ALV)
- Pension fund contributions
- Church tax calculations
- 13th month salary support
- Dark/Light theme support
- Multilingual support (German/English)
- Automatic canton rates updates

## Technical Details

### Architecture

The app follows a service-based architecture with:
- Services layer (`services/`) - Handles data fetching and business logic
- Models layer (`models/`) - Contains data structures and calculation logic
- UI layer (`screens/`) - Manages user interface and interactions

### Key Components

1. **Canton Rates Service**
   - Fetches current canton tax rates from API
   - Implements local caching with SharedPreferences
   - Falls back to default rates if network unavailable

2. **Contribution Rates**
   - Manages social security contribution rates
   - Handles canton-specific tax rates
   - Provides default values for offline use

3. **Salary Calculator**
   - Processes gross salary input
   - Applies all relevant deductions
   - Calculates net salary and yearly totals

## Setup & Installation

1. Ensure Flutter is installed and configured:
```bash
flutter doctor
```

2. Clone the repository:
```bash
git clone https://github.com/yourusername/lohnify.git
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Dependencies

- flutter_localizations: For internationalization
- http: For API requests
- shared_preferences: For local data storage
- json_annotation: For JSON serialization
- provider: For state management
- intl: For formatting and localization

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
