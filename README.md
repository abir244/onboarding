Flutter onboarding, location, and alarms
A polished Flutter mobile app built to demonstrate a complete onboarding experience, location permission and selection, and alarm notifications. Designed to match a Figma-inspired flow and optimized for interview-ready polish.

Overview
This app guides users through three onboarding screens, requests and displays their location, and lets them set alarms that trigger local notifications. It includes a map view with search (Places Autocomplete), a readable “Selected Location,” and an alarm list with toggles and a time picker.

Features
- Onboarding: Three screens with skip/next, navigation dots, and themed content.
- Location: GPS permission, map picker, and reverse geocoding to show a readable address.
- Search: Places Autocomplete to find locations like “Singapore” and pan the map.
- Alarms: Add alarms via a time picker and manage them in a clean list UI.
- Notifications: Local notifications when alarms go off using flutter_local_notifications.
- Design polish: Lato font, gradients, rounded corners, and interview-ready UX.

Tech stack and dependencies
- Flutter: Stable, Dart 3.x
- Maps and location:
- geolocator
- google_maps_flutter
- geocoding
- flutter_google_places_sdk
- Notifications: flutter_local_notifications
- Utilities: intl, provider (optional), http (optional)
Ensure all dependencies are added in pubspec.yaml and run flutter pub get.


Getting started
Prerequisites
- Flutter SDK: 3.10.x or higher
- Android/iOS setup: Xcode/Android Studio configured
- Google Cloud API key: Enabled for Maps JavaScript API and Places API
Install
git clone https://github.com/your-username/onboarding-app.git
cd onboarding-app
flutter pub get


Configure API keys
- Android: Add your Maps key to AndroidManifest.xml.
- iOS: Configure in AppDelegate.
- Web (if testing in Chrome): In web/index.html:
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places"></script>


- Restrict your key: Limit usage to required APIs and your app’s package/domain in Google Cloud Console.
Run
flutter run -d android
# or
flutter run -d ios
# optional web test
flutter run -d chrome



App flow
- Onboarding: PageView with skip/next; on completion, proceed to location.
- Location: Request permission, show map centered on current city; search updates camera and marker.
- Alarms: Floating action button opens time picker; alarms added to list and scheduled with notifications.

Screenshots
- Onboarding screens: Placeholder
- Location selection: Placeholder
- Alarms list: Placeholder
Add your images in a docs/ or assets/screenshots/ folder and embed them here.

Notes and recommendations
- Time zones: If using zoned scheduling, initialize the timezone package to ensure accurate notifications across regions.
- Local storage (optional): Persist alarms with Hive or SQLite so they survive app restarts.
- Permissions: Test location and notification permissions on real devices for accurate behavior.

License
- License: MIT (or your preferred license)
