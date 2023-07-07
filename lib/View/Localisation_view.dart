import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

import '../ViewModel/InfoCarbu_view_model.dart';

const accentCanvasColor = const Color(0xFF3E3E61);

class PagesLocalisation extends StatelessWidget {
  final Station stations;
  final List<Releve> releves;

  const PagesLocalisation({Key? key, required this.stations, required this.releves}) : super(key: key);
  static const pageTitle = 'Localisation';

  void _openGoogleMaps(BuildContext context, String googleMapsUrl) async {
    print(googleMapsUrl);
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
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

  void _openGoogleMapsIntent(BuildContext context, String googleMapsUrl) {
    print(googleMapsUrl);
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.parse(googleMapsUrl).toString(),
      package: 'com.google.android.apps.maps',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${stations.longitude}%2C${stations.latitude}';
    List<Releve> releveStation = releves.where((i) => i.idStation == stations.idStationsService).toList();

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
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(stations.longitude, stations.latitude),
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
                          point: LatLng(stations.longitude, stations.latitude),
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
                          onTap: () => launch('httpsopenstreetmap.org/copyright'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton.extended(
            onPressed: () {
              if (Theme.of(context).platform == TargetPlatform.android) {
                _openGoogleMapsIntent(context, googleMapsUrl);
              } else {
                _openGoogleMaps(context, googleMapsUrl);
              }
            },
            label: Text('Ouvrir dans Google Maps'),
            icon: Icon(Icons.map),
            backgroundColor: accentCanvasColor,
          ),
          SizedBox(height: 16.0),
          Text(
            'Nom station:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                stations.marque,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Station lieux:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                stations.adressePostale,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            flex: 1,
            child: Card(
              child: ListView.builder(
                primary: false,
                itemCount: releveStation.length,
                itemBuilder: (context, index) {
                  final releve = releveStation[index];
                    return Material(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Colors.grey[200],
                          title: Text(
                            releve.carburant.nom,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            '${releve.prixCarburant.toStringAsFixed(2)} €',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}