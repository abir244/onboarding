import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'alarm.dart';
import 'homescreen1.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isLoading = false;
  String? userLocation;
  LatLng? selectedLatLng;

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        userLocation = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        userLocation = "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}";
      });
    }
  }

  Future<void> getCurrentLocation() async {
    setState(() => isLoading = true);

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission denied"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      selectedLatLng = LatLng(position.latitude, position.longitude);
      await _getAddressFromLatLng(selectedLatLng!);
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location fetched successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching location: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> openMapPicker() async {
    LatLng tempLatLng =
        selectedLatLng ?? const LatLng(23.8103, 90.4125); // Dhaka default
    LatLng? picked;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 400,
            width: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: tempLatLng,
                zoom: 12,
              ),
              onTap: (latLng) {
                picked = latLng;
              },
              markers: {
                if (picked != null)
                  Marker(markerId: const MarkerId("picked"), position: picked!)
                else if (selectedLatLng != null)
                  Marker(
                    markerId: const MarkerId("current"),
                    position: selectedLatLng!,
                  ),
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (picked != null) {
                  setState(() {
                    selectedLatLng = picked;
                  });
                  await _getAddressFromLatLng(picked!);
                }
                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              //  Motivational text
              const Text(
                "Welcome! Your Smart Travel Alarm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Stay on schedule and enjoy every moment of your journey.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),

              //  Scenic image (rome.png)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/icons/rome.png', //  Make sure this image exists in your assets
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),

              //  Use GPS button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : getCurrentLocation,
                  icon: const Icon(Icons.my_location, color: Colors.white),
                  label: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Use Current Location",
                          style: TextStyle(fontSize: 18),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //  Pick location manually on map
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: openMapPicker,
                  icon: const Icon(Icons.map, color: Colors.white),
                  label: const Text(
                    "Pick Location on Map",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //  Navigate to AlarmPage
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AlarmPage()),
                    );
                  },
                  icon: const Icon(Icons.alarm, color: Colors.white),
                  label: const Text(
                    "Go to Alarms",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //  Show selected location
              if (userLocation != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Selected: $userLocation",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
