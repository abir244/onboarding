import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmf;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intl/intl.dart';

// Notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const kGoogleApiKey = "AIzaSyAlkZ1a1_D_luKPXY1CboKrHbCGLITPtpw";

// Notification plugin
final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final List<Map<String, dynamic>> alarms = [];

  String? selectedLocation;
  gmf.GoogleMapController? mapController;
  gmf.LatLng? selectedLatLng;

  late FlutterGooglePlacesSdk places;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize timezone database for notifications
    tz.initializeTimeZones();

    places = FlutterGooglePlacesSdk(kGoogleApiKey, locale: const Locale('en'));
  }

  @override
  void dispose() {
    mapController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  //  Schedule daily alarm using zonedSchedule
  // --------------------------------------------------------------------------
  Future<void> scheduleDailyAlarm(int id, TimeOfDay time) async {
    final androidDetails = AndroidNotificationDetails(
      'daily_alarm_channel',
      'Daily Alarms',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await notifications.zonedSchedule(
      id,
      "Alarm",
      "It's time!",
      scheduled,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeats daily
    );
  }

  Future<void> cancelAlarm(int id) async {
    await notifications.cancel(id);
  }

  // --------------------------------------------------------------------------
  //  Google Places Search
  // --------------------------------------------------------------------------
  Future<void> _searchLocation(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    final predictionsResult = await places.findAutocompletePredictions(q);
    final predictions = predictionsResult.predictions;
    if (predictions.isEmpty) return;

    final placeId = predictions.first.placeId;

    final details = await places.fetchPlace(
      placeId,
      fields: [PlaceField.Location, PlaceField.Name],
    );

    final place = details.place;
    final latLngLiteral = place?.latLng;
    if (latLngLiteral == null) return;

    final mapLatLng = gmf.LatLng(latLngLiteral.lat, latLngLiteral.lng);

    setState(() {
      selectedLocation = place?.name ?? "Selected Location";
      selectedLatLng = mapLatLng;
    });

    mapController?.animateCamera(gmf.CameraUpdate.newLatLng(mapLatLng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF3A0CA3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Selected Location",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // ---------------------- Search Bar ----------------------
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search location...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => _searchLocation(searchController.text),
                  ),
                ),
                onSubmitted: _searchLocation,
              ),

              const SizedBox(height: 20),

              // ---------------------- Map ----------------------
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: gmf.GoogleMap(
                    initialCameraPosition: const gmf.CameraPosition(
                      target: gmf.LatLng(23.8103, 90.4125),
                      zoom: 12,
                    ),
                    onMapCreated: (controller) => mapController = controller,
                    markers: selectedLatLng != null
                        ? {
                            gmf.Marker(
                              markerId: const gmf.MarkerId("selected"),
                              position: selectedLatLng!,
                              infoWindow: gmf.InfoWindow(
                                title: selectedLocation ?? "Selected Location",
                              ),
                            ),
                          }
                        : {},
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Alarms",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // ---------------------- Alarm List ----------------------
              Expanded(
                child: ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alarm["timeString"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Repeats daily",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          // SWITCH
                          Switch(
                            value: alarm["enabled"],
                            onChanged: (value) async {
                              setState(() {
                                alarms[index]["enabled"] = value;
                              });

                              if (value) {
                                await scheduleDailyAlarm(
                                  alarm["id"],
                                  alarm["time"],
                                );
                              } else {
                                await cancelAlarm(alarm["id"]);
                              }
                            },
                            activeColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ---------------------- Add Alarm Button ----------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            final formattedTime = pickedTime.format(context);
            final alarmId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

            setState(() {
              alarms.add({
                "id": alarmId,
                "time": pickedTime,
                "timeString": formattedTime,
                "enabled": true,
              });
            });

            await scheduleDailyAlarm(alarmId, pickedTime);
          }
        },
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.alarm_add),
      ),
    );
  }
}
