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
  List<InfoStation> InfoStations = [];
  List<InfoStation> favoris = [];
  bool isLoading = false;
  bool reachedEnd = false;

  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
    _fetchInfoStations();
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
        _fetchInfoStations();
      });
    }
  }

  Future<void> _fetchInfoStations() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<InfoStation> fetchInfoStations = await _apiService.fetchInfoStations();

      setState(() {
        InfoStations.addAll(fetchInfoStations);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFavori(InfoStation favori) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3E3E61),
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
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: InfoStations.length + 1,
        itemBuilder: (context, index) {
          if (index < InfoStations.length) {
            InfoStation infoStation = InfoStations[index];
            bool isFavori = favoris.contains(infoStation);

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
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text(
                            infoStation.marque,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            infoStation.ville,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            infoStation.adressePostale,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _toggleFavori(infoStation);
                      },
                      icon: Icon(
                        isFavori ? Icons.star : Icons.star_border,
                        color: isFavori ? Colors.yellow : Colors.grey,
                      ),
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
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF3E3E61),
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
                        builder: (context) =>
                            ListFavorisView(favoris: favoris, removeFavori: _toggleFavori),
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
                        ),
                      ],
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
