import 'package:dragable/template_flow.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IconsWidget extends StatelessWidget {
  const IconsWidget({super.key});

  // Function to launch the LinkedIn profile URL
  Future<void> _launchLinkedIn() async {
    const url =
        'https://www.linkedin.com/in/sufyankamil/';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Draggable Icons',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle,color: Colors.white,), // Profile icon
            onPressed: _launchLinkedIn, // Open LinkedIn profile when clicked
          ),
        ],
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Dock(
          items: const [
            Icons.person,
            Icons.message,
            Icons.call,
            Icons.camera,
            Icons.photo,
          ],
          builder: (e) {
            return Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.primaries[e.hashCode % Colors.primaries.length],
              ),
              child: Center(child: Icon(e, color: Colors.white)),
            );
          },
          indexHovered: 2,
        ),
      ),
    );
  }
}
