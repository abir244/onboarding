import 'package:flutter/material.dart';
import 'homescreen1.dart';
import 'screen3.dart';
import 'location_page.dart';

class ScreenSecond extends StatelessWidget {
  const ScreenSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 Top half: sea.png background
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.asset(
                      'assets/icons/sea.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 🔹 Preview button (top-left → HomePage)
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    },
                    child: const Text(
                      "Preview",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 🔹 Skip button (top-right → LocationPage)
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LocationPage()),
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Bottom half: blue background
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Effortless & Automatic Syncing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Your files, photos, and settings stay updated everywhere.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "No more manual transfers or worrying about losing data. "
                    "Whether you switch devices or go offline, everything is backed up and ready when you are.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Navigation dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_dot(false), _dot(true), _dot(false)],
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Next button → ScreenThird (bottom side)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ScreenThird()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Tip: You can always enable syncing later in settings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Dot widget
  Widget _dot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white38,
        shape: BoxShape.circle,
      ),
    );
  }
}
