import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

const accentCanvasColor = const Color(0xFF3E3E61);

class PagesLocalisation extends StatelessWidget {
  const PagesLocalisation({Key? key}) : super(key: key);

  static const pageTitle = 'Lieux';
  static const googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=St+Jean+Douai';

  void _openGoogleMaps(BuildContext context) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=St+Jean+Douai';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Impossible de lancer Google Maps.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _openGoogleMapsIntent(BuildContext context) {
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.parse(googleMapsUrl).toString(),
      package: 'com.google.android.apps.maps',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentCanvasColor,
        title: Row(
          children: [
            Icon(
              Icons.map,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                pageTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(50.369465744099635, 3.0860044668324575),
                    zoom: 17.50,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(50.369465744099635, 3.0860044668324575),
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  nonRotatedChildren: [
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launch('https://openstreetmap.org/copyright'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (Theme.of(context).platform == TargetPlatform.android) {
              _openGoogleMapsIntent(context);
            } else {
              _openGoogleMaps(context);
            }
          },
          label: Text('Ouvrir dans Google Maps'),
          icon: Icon(Icons.map),
          backgroundColor: accentCanvasColor,
        ),
      ),
    );
  }
}
