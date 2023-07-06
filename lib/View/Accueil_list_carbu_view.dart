import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tucarbure/ViewModel/InfoCarbu_view_model.dart';
import 'package:tucarbure/View/List_favoris_view.dart';
import 'package:tucarbure/View/Localisation_view.dart';

const accentCanvasColor = const Color(0xFF3E3E61);
const pageTitle = 'Accueil';

class PageAccueil extends StatefulWidget {
  @override
  _PageAccueilState createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  ScrollController _scrollController = ScrollController();
  List<Releve> releves = [];
  Set<Station> favoris = Set<Station>();
  bool isLoading = false;
  bool reachedEnd = false;
  String _selectedFuel = 'Tous'; // Added selected fuel variable

  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
    _fetchReleves();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        !reachedEnd) {
      // Utilisez le délai pour éviter les appels redondants
      Timer(Duration(milliseconds: 200), () {
        _fetchReleves();
      });
    }
  }

  Future<void> _fetchReleves() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Releve> fetchReleves = await _apiService.fetchReleves();

      setState(() {
        releves.addAll(fetchReleves);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFavori(Station favori) {
    setState(() {
      if (favoris.contains(favori)) {
        favoris.remove(favori);
      } else {
        favoris.add(favori);
      }
    });
  }

  void _navigateToPageLocalisation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PagesLocalisation()),
    );
  }

  List<Releve> _buildFavorisFirstList() {
    List<Releve> favorisFirst = [];

    // Filter the releves list based on the selected fuel
    List<Releve> filteredReleves = releves.where((releve) {
      if (_selectedFuel == 'Tous') {
        return true; // Include all items when 'Tous' is selected
      } else {
        return releve.carburant.nom == _selectedFuel;
      }
    }).toList();

    // Add the relevés corresponding to the favoris first in the list
    for (Releve releve in filteredReleves) {
      if (favoris.contains(releve.station)) {
        favorisFirst.add(releve);
      }
    }

    // Add the other relevés to the list
    for (Releve releve in filteredReleves) {
      if (!favoris.contains(releve.station)) {
        favorisFirst.add(releve);
      }
    }

    return favorisFirst;
  }

void _showPriceModificationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modifier le prix',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nouveau prix',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentCanvasColor),
                    ),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: accentCanvasColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      child: Text(
                        'Valider',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: accentCanvasColor,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: Effectuer la modification du prix
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Releve> favorisFirst = _buildFavorisFirstList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentCanvasColor,
        title: Row(
          children: [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Accueil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF001931)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFuel,
                items: <String>[
                  'Tous',
                  'Sans Plomb 98 (E5)',
                  'Sans Plomb 95 (E5)',
                  'Sans Plomb 95 (E10)',
                  'Gazole (B7)',
                  'Diesel'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Color(0xFF001931)),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFuel = newValue!;
                  });
                },
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: favorisFirst.length+ 1,
            itemBuilder: (context, index) {
              if (index < favorisFirst.length) {
                Releve releve = favorisFirst[index];
                bool isFavori = favoris.contains(releve.station);

                return GestureDetector(
                  onTap: _navigateToPageLocalisation,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 15.0,
                          height: 15.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.0),
                              Text(
                                releve.station.marque,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                releve.station.ville,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                releve.station.adressePostale,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _toggleFavori(releve.station);
                          },
                          icon: Icon(
                            isFavori ? Icons.star : Icons.star_border,
                            color: isFavori ? Colors.yellow : Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showPriceModificationPopup();
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (isLoading) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                reachedEnd = true;
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('Fin des actualités')),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: accentCanvasColor,
        child: Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 110.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListFavorisView(
                          favoris: favoris.toList(),
                          removeFavori: _toggleFavori,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 35.0,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                    )],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.black,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          'Favoris',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
