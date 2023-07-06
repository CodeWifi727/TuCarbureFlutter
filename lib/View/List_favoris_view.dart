import 'package:flutter/material.dart';
import 'package:tucarbure/ViewModel/InfoCarbu_view_model.dart';

class ListFavorisView extends StatefulWidget {
  final List<Station> favoris;
  final Function(Station) removeFavori;

  ListFavorisView({required this.favoris, required this.removeFavori});

  @override
  _ListFavorisViewState createState() => _ListFavorisViewState();
}

class _ListFavorisViewState extends State<ListFavorisView> {
  List<bool> isFavoriteList = List.filled(0, false);

  @override
  void initState() {
    super.initState();
    // Initialize the isFavoriteList based on the initial favoris list
    isFavoriteList = List.generate(widget.favoris.length, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3E3E61),
        title: Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Favoris',
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
        itemCount: widget.favoris.length,
        itemBuilder: (context, index) {
          Station favori = widget.favoris[index];

          return Container(
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
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        favori.marque,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        favori.ville,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        favori.adressePostale,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFavoriteList[index] = !isFavoriteList[index];
                    });
                    widget.removeFavori(favori);
                  },
                  icon: Icon(
                    Icons.star,
                    color: isFavoriteList[index] ? Colors.yellow : Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
