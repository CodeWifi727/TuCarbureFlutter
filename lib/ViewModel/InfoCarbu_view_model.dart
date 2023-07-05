import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http_io;

class ApiService {
  static const String apiUrl = 'https://192.168.1.23:7033/Station';

  Future<List<InfoStation>> fetchInfoStations() async {
    // Créer un client HTTP en désactivant la vérification du certificat
    http.Client client = http_io.IOClient(
      HttpClient()..badCertificateCallback = (cert, host, port) => true,
    );

    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<InfoStation>.from(
          jsonData.map((data) => InfoStation.fromJson(data)));
    } else {
      throw Exception('Failed to fetch InfoCarbu from API');
    }
  }
}

class InfoStation {
  final int idStationsService;
  final String marque;
  final String adressePostale;
  final String longitude;
  final String latitude;
  final String ville;

  InfoStation({
    required this.idStationsService,
    required this.marque,
    required this.adressePostale,
    required this.longitude,
    required this.latitude,
    required this.ville,
  });

  factory InfoStation.fromJson(Map<String, dynamic> json) {
    return InfoStation(
      idStationsService: json['idStationsService'],
      marque: json['marque'],
      adressePostale: json['adressePostale'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      ville: json['ville'],
    );
  }
}
