import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http_io;

class ApiService {
  static const String apiUrl = 'https://192.168.1.23:7033';

  Future<List<Releve>> fetchReleves() async {
    // Créer un client HTTP en désactivant la vérification du certificat
    http.Client client = http_io.IOClient(
      HttpClient()..badCertificateCallback = (cert, host, port) => true,
    );

    final response = await client.get(Uri.parse('$apiUrl/Releve'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Releve>.from(jsonData.map((data) => Releve.fromJson(data)));
    } else {
      throw Exception('Failed to fetch Releves from API');
    }
  }
}

class Releve {
  int idReleve;
  DateTime dateHeure;
  double prixCarburant;
  int idCarburant;
  Carburant carburant;
  int idStation;
  Station station;

  Releve({
    required this.idReleve,
    required this.dateHeure,
    required this.prixCarburant,
    required this.idCarburant,
    required this.carburant,
    required this.idStation,
    required this.station,
  });

  factory Releve.fromJson(Map<String, dynamic> json) {
    return Releve(
      idReleve: json['idReleve'],
      dateHeure: DateTime.parse(json['dateHeure']),
      prixCarburant: (json['prixCarburant'] is String)
          ? double.parse(json['prixCarburant'].replaceAll(',', '.'))
          : (json['prixCarburant'] is int)
          ? (json['prixCarburant'] as int).toDouble()
          : json['prixCarburant'].toDouble(),
      idCarburant: json['idCarburant'],
      carburant: Carburant.fromJson(json['carburant']),
      idStation: json['idStation'],
      station: Station.fromJson(json['station']),
    );
  }
}

class Carburant {
  int idCarburant;
  String nom;
  String codeEuropeen;

  Carburant({
    required this.idCarburant,
    required this.nom,
    required this.codeEuropeen,
  });

  factory Carburant.fromJson(Map<String, dynamic> json) {
    return Carburant(
      idCarburant: json['idCarburant'],
      nom: json['nom'],
      codeEuropeen: json['codeEuropeen'],
    );
  }
}

class Station {
  int idStationsService;
  String marque;
  String adressePostale;
  double longitude;
  double latitude;
  String ville;

  Station({
    required this.idStationsService,
    required this.marque,
    required this.adressePostale,
    required this.longitude,
    required this.latitude,
    required this.ville,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      idStationsService: json['idStationsService'],
      marque: json['marque'],
      adressePostale: json['adressePostale'],
      longitude: (json['longitude'] is String)
          ? double.parse(json['longitude'])
          : json['longitude'],
      latitude: (json['latitude'] is String)
          ? double.parse(json['latitude'])
          : json['latitude'],
      ville: json['ville'],
    );
  }
}
