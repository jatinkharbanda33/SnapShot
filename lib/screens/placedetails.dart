import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import './maps_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;
  String get getimage {
    if (place == null) return '';
    final lat = place.location.latitude;
    final lon = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyBNrliwZO8-nAE_ef51MhECBgDZhZEBKoY';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(border: Border.all(width: 3.0)),
              child: Image(
                image: FileImage(place.itsiamge),
                fit: BoxFit.cover,
              )),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 61,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) =>  MapScreen(itslocation:place.location ,isselecting: true,))));
              },
              child: CircleAvatar(
                radius: 61,
                backgroundImage: CachedNetworkImageProvider(getimage),
              ),
            ),
          )
        ],
      ),
    );
  }
}
