import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://192.168.187.93:8000/api/actualites'; // Remplace cette URL par celle de ton API Symfony

  Future<List<Actualite>> fetchActualites() async {
    final response = await http.get(Uri.parse('$apiUrl')); // Endpoint pour récupérer les actualités

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Actualite>.from(jsonData.map((data) => Actualite.fromJson(data)));
    } else {
      throw Exception('Failed to fetch actualites from API');
    }
  }
}

class Actualite {
  final String titre;
  final String description;
  final String image;
  final DateTime date;

  Actualite({
    required this.titre,
    required this.description,
    required this.image,
    required this.date,
  });

  factory Actualite.fromJson(Map<String, dynamic> json) {
    return Actualite(
      titre: json['titre'],
      description: json['description'],
      image: json['image'],
      date: DateTime.parse(json['date']),
    );
  }
}
